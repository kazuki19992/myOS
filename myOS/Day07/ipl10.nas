; haribote-ipl10
; TAB=4

CYLS EQU 10                 ; CYLS = 10と定義する

    ORG     0x7c00

; disk
    JMP     SHORT   entry
    DB      0x90
    DB      "HARIBOTE"      ; ブートセクタの名前(8バイト)
    DW      512             ; 1セクタの大きさ
    DB      1               ; クラスタの大きさ
    DW      1               ; FATの始まりの位置
    DB      2               ; FAT個数(2にしなければならない)
    DW      224             ; ルートディレクトリの大きさ(通常は224エントリ)
    DW      2880            ; このドライブの大きさ(2880にしなければならない)
    DB      0xf0            ; メディアタイプ(0xf0にせねばならない)
    DW      9               ; FAT領域の長さ(9にせねばならない)
    DW      18              ; 1トラックにいくつのセクタが存在するか(18にせねばならない)
    DW      2               ; ヘッドの数(2にせねばならない)
    DD      0               ; パーティションを使用していないので0
    DD      2880            ; このドライブの大きさをもう一度

    ; FAT12/16におけるオフセット36以降のフィールド
    ; DB      0,0,0x29        ; この値にしておくと幸せになれるらしい……？
    DB      0x00            ; BS_DrvNum
    DB      0x00            ; BS_Reserved1
    DB      0x29            ; BS_BootSig


    DD      0xffffffff      ; おそらくボリュームシリアル番号
    DB      "HARIBOTEOS "   ; ディスク名称(11バイト)
    DB      "FAT12   "      ; フォーマットの名前(8バイト)
    TIMES   18      DB    0 ; とりあえず18バイト空けておくらしい

; Start BS_BootCode 64(0x14)    448(0x1C0)
entry:
    MOV     AX, 0           ; レジスタ初期化
    MOV     SS, AX
    MOV     SP, 0x7c00
    MOV     DS, AX

; ディスクを読む
    MOV     AX, 0x0820
    MOV     ES, AX
    MOV     CH, 0           ; シリンダ0
    MOV     DH, 0           ; ヘッド0
    MOV     CL, 2           ; セクタ2

readloop:
    MOV     SI, 0           ; 失敗回数のリセット

retry:
    MOV     AH, 0x02        ; AH = 0x02 : ディスク読み込み  INT命令用
    MOV     AL, 1           ; 1セクタ
    MOV     BX, 0

    MOV     DL, 0x00        ; Aドライブ
    INT     0x13            ; ディスクBIOS呼び出し
    JNC     next            ; エラーなければnext

    ADD     SI, 1           ; SIレジスタ + 1
    CMP     SI, 5           ; SIと5を比較
    JAE     error           ; SI >= 5の場合errorへ

    MOV     AH, 0x00        ; INT命令用
    MOV     DL, 0x00        ; ドライブ番号0
    INT     0x13            ; discBIOSを呼び出す
    JMP     retry

next:
    MOV     AX, ES          ; アドレスを0x200(512 = 1セクタ分進める)
    ADD     AX, 0x0020
    MOV     ES, AX          ; ADD ES, 200という命令がない

    ADD     CL, 1           ; セクタ番号を1増やす
    CMP     CL, 18          ; CLと18を比較
    JBE     readloop        ; CL <= 18の場合readloopへ

    ; ディスクの裏面
    MOV     CL, 1
    ADD     DH, 1           ; ヘッダ番号を1増やす
    CMP     DH, 2           ; DHと2を比較
    JB      readloop        ; DH < 2の時readloopへ

    MOV     DH, 0           ; DH = 0
    ADD     CH, 1           ; シリンダ番号を1増やす
    CMP     CH, CYLS        ; CHとCYLS(=10)を比較
    JB      readloop        ; CH < CYLSの時readloop

    ; ブートセクタの読み込みが終わったのでOSの実行
    MOV     [0x0ff0], CH    ; IPLがどこまで読んだのかメモ
    JMP     0xc200

error:
    MOV     SI, msg

putloop:
    MOV     AL, [SI]
    ADD     SI, 1
    CMP     AL, 0
    JE      fin

    MOV     AH, 0x0e        ; 一文字表示ファンクション
    MOV     BX, 15          ; カラーコード
    INT     0x10            ; ビデオBIOS呼び出し(INTは割り込みという意味らしい)
    JMP     putloop

fin:
    HLT                     ; 何かあるまでCPU停止
    JMP     fin             ; 無限ループ

; メッセージ部分
msg:
    DB      0x0a, 0x0a      ; 改行 * 2
    DB      "load error"
    DB      0x0a            ; 改行
    DB      0
    
    ; RESB    0x1fe-$         ; 0x001feまでを0x00で埋める命令  ←この方法だと動かなかった！僕の環境だけ？
    TIMES   0x7dfe - 0x7c00 - ($-$$)    DB  0
    ; TIMES   0x7dfe-0x7c00-($-$$)    DB      0


    DB      0x55, 0xaa