{
    Bastisoft Tetris for OS/2
    Copyright (C) 2002  Sebastian Koppehel

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program; if not, write to the Free Software
    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
}

PROGRAM Tetris;

{$PMTYPE PM}

USES Use32, Os2Base, Os2Def, Os2PmApi, Strings;

TYPE TTeil = Array[1..5] of PointL;

CONST VerNum= '1.02';
      Titel = 'Bastisoft Tetris';
      WinFlags  : uLong = fcf_TitleBar or fcf_SysMenu or fcf_MinButton or fcf_Tasklist or fcf_Icon or fcf_DlgBorder;

      StandardTeil1 : TTeil = ((x:6;y:20),(x:6;y:19),(x:6;y:18),(x:6;y:17),(x:1;y:1));
      StandardTeil2 : TTeil = ((x:5;y:20),(x:5;y:19),(x:6;y:20),(x:5;y:18),(x:2;y:1));
      StandardTeil3 : TTeil = ((x:6;y:20),(x:5;y:20),(x:6;y:19),(x:6;y:18),(x:3;y:1));
      StandardTeil4 : TTeil = ((x:5;y:20),(x:5;y:19),(x:6;y:19),(x:6;y:18),(x:4;y:1));
      StandardTeil5 : TTeil = ((x:6;y:20),(x:5;y:19),(x:6;y:19),(x:5;y:18),(x:5;y:1));
      StandardTeil6 : TTeil = ((x:6;y:20),(x:5;y:19),(x:6;y:19),(x:6;y:18),(x:6;y:1));
      StandardTeil7 : TTeil = ((x:5;y:20),(x:5;y:19),(x:6;y:20),(x:6;y:19),(x:7;y:1));

      Drehung : Array[1..7] of Array[1..4] of TTeil
                = ( ( ((x:-1;y:-2),(x:-2;y:-1),(x:1;y:0),  (x:0;y:1),  (x:0;y:0)),
                      ((x:1;y:2),  (x:2;y:1),  (x:-1;y:0), (x:0;y:-1), (x:0;y:0)),
                      ((x:-1;y:-2),(x:-2;y:-1),(x:1;y:0),  (x:0;y:1),  (x:0;y:0)),
                      ((x:1;y:2),  (x:2;y:1),  (x:-1;y:0), (x:0;y:-1), (x:0;y:0)) ),
                    ( ((x:-1;y:0), (x:-1;y:0), (x:0;y:-1), (x:0;y:1),  (x:0;y:0)),
                      ((x:1;y:0),  (x:0;y:-1), (x:-1;y:0), (x:0;y:-1), (x:0;y:0)),
                      ((x:0;y:-1), (x:0;y:1),  (x:1;y:0),  (x:1;y:0),  (x:0;y:0)),
                      ((x:0;y:1),  (x:1;y:0),  (x:0;y:1),  (x:-1;y:0), (x:0;y:0)) ),
                    ( ((x:0;y:-1), (x:0;y:-1), (x:1;y:0),  (x:-1;y:0), (x:0;y:0)),
                      ((x:0;y:1),  (x:1;y:0),  (x:0;y:-1), (x:1;y:0),  (x:0;y:0)),
                      ((x:1;y:0),  (x:-1;y:0), (x:0;y:1),  (x:0;y:1),  (x:0;y:0)),
                      ((x:-1;y:0), (x:0;y:1),  (x:-1;y:0), (x:0;y:-1), (x:0;y:0)) ),
                    ( ((x:1;y:-1), (x:0;y:-1), (x:1;y:0),  (x:0;y:0),  (x:0;y:0)),
                      ((x:-1;y:1), (x:0;y:1),  (x:-1;y:0), (x:0;y:0),  (x:0;y:0)),
                      ((x:1;y:-1), (x:0;y:-1), (x:1;y:0),  (x:0;y:0),  (x:0;y:0)),
                      ((x:-1;y:1), (x:0;y:1),  (x:-1;y:0), (x:0;y:0),  (x:0;y:0)) ),
                    ( ((x:0;y:-1), (x:0;y:0),  (x:1;y:-1), (x:1;y:0),  (x:0;y:0)),
                      ((x:0;y:1),  (x:0;y:0),  (x:-1;y:1), (x:-1;y:0), (x:0;y:0)),
                      ((x:0;y:-1), (x:0;y:0),  (x:1;y:-1), (x:1;y:0),  (x:0;y:0)),
                      ((x:0;y:1),  (x:0;y:0),  (x:-1;y:1), (x:-1;y:0), (x:0;y:0)) ),
                    ( ((x:0;y:-1), (x:0;y:0),  (x:1;y:0),  (x:0;y:0),  (x:0;y:0)),
                      ((x:0;y:1),  (x:1;y:0),  (x:0;y:0),  (x:0;y:0),  (x:0;y:0)),
                      ((x:0;y:0),  (x:-1;y:0), (x:0;y:0),  (x:0;y:1),  (x:0;y:0)),
                      ((x:0;y:0),  (x:0;y:0),  (x:-1;y:0), (x:0;y:-1), (x:0;y:0)) ),
                    ( ((x:0;y:0),  (x:0;y:0),  (x:0;y:0),  (x:0;y:0),  (x:0;y:0)),
                      ((x:0;y:0),  (x:0;y:0),  (x:0;y:0),  (x:0;y:0),  (x:0;y:0)),
                      ((x:0;y:0),  (x:0;y:0),  (x:0;y:0),  (x:0;y:0),  (x:0;y:0)),
                      ((x:0;y:0),  (x:0;y:0),  (x:0;y:0),  (x:0;y:0),  (x:0;y:0)) ) );

      id_Rot       = 101;
      id_Gruen     = 102;
      id_Blau      = 103;
      id_Gelb      = 104;
      id_Lila      = 105;
      id_LBmp      = 106;
      id_RBmp      = 107;
      id_Icon      = 108;

      id_Reset     = 201;
      id_Ende      = 202;
      id_Speed     = 203;
      id_Score     = 204;
      id_Pause     = 205;
      id_Timer     = 206;
      id_Links     = 207;
      id_Rechts    = 208;
      id_Curr      = 209;
      id_HiScore   = 210;

      id_HSDlg     = 301;
      id_NameDlg   = 302;
      id_NameEntry = 303;

      id_Name      = 400;
      id_Point     = 500;

VAR  habAnchor : HAB;
     hmqQueue : HMQ;
     hwndFrame : HWND;
     hwndClient : HWND;
     qmMsg : QMSG;
     Groesse : PointL;
     Farbe : RGB2;

     Feld : Array[1..10,1..20] of Char;
     Teil, Next : TTeil;
     GameOver, Pause : Boolean;
     Punkte : LongInt;
     StartSpeed, CurrentSpeed : LongInt;
     SpeedString : Array[0..255] of Char;
     Klicks : Word;
     NewName : String;

     RotBmp, GruenBmp, BlauBmp, GelbBmp, LilaBmp : hBitmap;
     WinFont : Array[0..255] of Char;
     SmallFont : Boolean;

     HiScore : Array[1..10] of RECORD
                               Name : String;
                               Score : LongInt;
                               END;

FUNCTION NameDlgProc(Window : hWnd; Msg : uLong; Mp1, Mp2 : MParam) : MResult; cdecl;
VAR Ausgabe : Array[0..255] of Char;
BEGIN
CASE Msg OF
   wm_InitDlg : BEGIN
                StrPCopy(Ausgabe,NewName);
                WinSetWindowText(WinWindowFromId(Window,id_NameEntry),Ausgabe);
                WinSendMsg(WinWindowFromId(Window,id_NameEntry),em_SetSel,MpFrom2Short(0,Length(NewName)),0);
                NameDlgProc := WinDefDlgProc(Window,Msg,Mp1,Mp2);
                END;
   wm_Command : BEGIN
                If LongFromMp(Mp1) = did_Ok then
                   BEGIN
                   WinQueryWindowText(WinWindowFromId(Window,id_NameEntry),SizeOf(Ausgabe),Ausgabe);
                   NewName := StrPas(Ausgabe);
                   END;
                NameDlgProc := WinDefDlgProc(Window,Msg,Mp1,Mp2);
                END;
   ELSE NameDlgProc := WinDefDlgProc(Window,Msg,Mp1,Mp2);
   END;
END;

PROCEDURE NameHolen;
BEGIN
WinDlgBox(hwnd_Desktop,hwndClient,NameDlgProc,0,id_NameDlg,nil);
IF NewName = '' then NewName := '[Keine Angabe]';
END;

FUNCTION HSDlgProc(Window : hWnd; Msg : uLong; Mp1, Mp2 : MParam) : MResult; cdecl;
VAR a : Byte;
    Ausgabe : Array[0..255] of Char;
BEGIN
CASE Msg OF
   wm_InitDlg : BEGIN
                FOR a := 1 to 10 DO
                   BEGIN
                   StrPCopy(Ausgabe,HiScore[a].Name);
                   WinSetWindowText(WinWindowFromId(Window,id_Name+a),Ausgabe);
                   Str(HiScore[a].Score,Ausgabe);
                   WinSetWindowText(WinWindowFromId(Window,id_Point+a),Ausgabe);
                   END;
                HSDlgProc := WinDefDlgProc(Window,Msg,Mp1,Mp2);
                END;
   ELSE HSDlgProc := WinDefDlgProc(Window,Msg,Mp1,Mp2);
   END;
END;

PROCEDURE ShowHiScore;
BEGIN
WinDlgBox(hwnd_Desktop,hwndClient,HSDlgProc,0,id_HSDlg,nil);
END;

PROCEDURE MoveTo(PS : hPS; x,y : Long);
VAR P : PointL;
BEGIN
P.x := x;
P.y := y;
GpiMove(PS,P);
END;

PROCEDURE LineTo(PS : hPS; x,y : Long);
VAR P : PointL;
BEGIN
P.x := x;
P.y := y;
GpiLine(PS,P);
END;

PROCEDURE DrawNext(PS : hPS);
VAR P : PointL;
    a : Byte;
BEGIN
GpiSetColor(PS,clr_Black);
MoveTo(PS,227,260);
P.x := 325;
P.y := 380;
GpiBox(PS,dro_Fill,p,0,0);

IF not GameOver then FOR a:= 1 to 4 DO
   BEGIN
   P.x := 257+(Next[a].x-5)*20;
   P.y := 280+(Next[a].y-17)*20;
   CASE Next[5].x OF
      1   : WinDrawBitmap(PS,RotBmp,nil,@P,0,0,dbm_Normal);
      2,3 : WinDrawBitmap(PS,GruenBmp,nil,@P,0,0,dbm_Normal);
      4,5 : WinDrawBitmap(PS,BlauBmp,nil,@P,0,0,dbm_Normal);
      6   : WinDrawBitmap(PS,GelbBmp,nil,@P,0,0,dbm_Normal);
      7   : WinDrawBitmap(PS,LilaBmp,nil,@P,0,0,dbm_Normal);
      END;
   END;
END;

PROCEDURE DrawFeld(PS : hPS);
VAR P : PointL;
    FeldX, FeldY : Byte;
BEGIN
GpiSetColor(PS,clr_Black);
MoveTo(PS,10,10);
P.x := 210;
P.y := 410;
GpiBox(PS,dro_Fill,P,0,0);
FOR FeldY := 1 to 20 DO
   FOR FeldX := 1 to 10 DO
      BEGIN
      IF Feld[FeldX,FeldY] <> ' ' then
         BEGIN
         P.x := 10+(FeldX-1)*20;
         P.y := 10+(FeldY-1)*20;
         CASE Feld[FeldX,FeldY] OF
            '1'     : WinDrawBitmap(PS,RotBmp,nil,@P,0,0,dbm_Normal);
            '2','3' : WinDrawBitmap(PS,GruenBmp,nil,@P,0,0,dbm_Normal);
            '4','5' : WinDrawBitmap(PS,BlauBmp,nil,@P,0,0,dbm_Normal);
            '6'     : WinDrawBitmap(PS,GelbBmp,nil,@P,0,0,dbm_Normal);
            '7'     : WinDrawBitmap(PS,LilaBmp,nil,@P,0,0,dbm_Normal);
            END;
         END;
      END;
END;

PROCEDURE Zeichnen(PS : hPS);
VAR P : PointL;
    a : Word;
BEGIN
GpiSetColor(PS,clr_PaleGray);
GpiBox(PS,dro_Fill,Groesse,0,0);

GpiSetColor(PS,clr_DarkGray);
MoveTo(PS,8,8);
LineTo(PS,8,412);
LineTo(PS,212,412);
MoveTo(PS,211,411);
LineTo(PS,9,411);
LineTo(PS,9,9);
GpiSetColor(PS,clr_White);
MoveTo(PS,8,8);
LineTo(PS,212,8);
LineTo(PS,212,412);
MoveTo(PS,211,411);
LineTo(PS,211,9);
LineTo(PS,9,9);

DrawFeld(PS);

IF not GameOver then
   BEGIN
   FOR a := 1 to 4 DO
      BEGIN
      P.x := 10+(Teil[a].x-1)*20;
      P.y := 10+(Teil[a].y-1)*20;
      CASE Teil[5].x OF
         1   : WinDrawBitmap(PS,RotBmp,nil,@P,0,0,dbm_Normal);
         2,3 : WinDrawBitmap(PS,GruenBmp,nil,@P,0,0,dbm_Normal);
         4,5 : WinDrawBitmap(PS,BlauBmp,nil,@P,0,0,dbm_Normal);
         6   : WinDrawBitmap(PS,GelbBmp,nil,@P,0,0,dbm_Normal);
         7   : WinDrawBitmap(PS,LilaBmp,nil,@P,0,0,dbm_Normal);
         END;
      END;
   END;

GpiSetColor(PS,clr_Black);
MoveTo(PS,227,260);
P.x := 325;
P.y := 380;
GpiBox(PS,dro_Fill,p,0,0);
GpiSetColor(PS,clr_DarkGray);
MoveTo(PS,225,258);
LineTo(PS,225,382);
LineTo(PS,327,382);
MoveTo(PS,326,381);
LineTo(PS,226,381);
LineTo(PS,226,259);
GpiSetColor(PS,clr_White);
MoveTo(PS,225,258);
LineTo(PS,327,258);
LineTo(PS,327,382);
MoveTo(PS,326,381);
LineTo(PS,326,259);
LineTo(PS,226,259);

DrawNext(PS);
END;

FUNCTION GetRandomTeil : TTeil;
VAR a : Byte;
BEGIN
a := Random(7) + 1;
CASE a OF
   1 : GetRandomTeil := StandardTeil1;
   2 : GetRandomTeil := StandardTeil2;
   3 : GetRandomTeil := StandardTeil3;
   4 : GetRandomTeil := StandardTeil4;
   5 : GetRandomTeil := StandardTeil5;
   6 : GetRandomTeil := StandardTeil6;
   7 : GetRandomTeil := StandardTeil7;
   END;
END;

FUNCTION MovePossible(DeltaX, DeltaY : Integer) : Boolean;
VAR a : Byte;
BEGIN
IF (not (Teil[1].y+DeltaY IN [1..20])) OR (not (Teil[2].x+DeltaX IN [1..10])) OR
   (not (Teil[3].x+DeltaX IN [1..10])) OR (not (Teil[4].y+DeltaY IN [1..20]))
   then MovePossible := False
ELSE
   BEGIN
   MovePossible := True;
   FOR a := 1 to 4 DO IF Feld[Teil[a].x+DeltaX,Teil[a].y+DeltaY] <> ' ' then MovePossible := False;
   END;
END;

PROCEDURE MoveTeil(DeltaX,DeltaY : Integer);
VAR PS : hPS;
    P : PointL;
    a : byte;
BEGIN
PS := WinGetPS(hwndClient);
GpiSetColor(PS,clr_Black);
FOR a := 1 to 4 DO
   BEGIN
   MoveTo(PS,10+(Teil[a].x-1)*20,10+(Teil[a].y-1)*20);
   P.x := 10+Teil[a].x*20-1;
   P.y := 10+Teil[a].y*20-1;
   GpiBox(PS,dro_Fill,P,0,0);
   END;
FOR a := 1 to 4 DO
   BEGIN
   Teil[a].x := Teil[a].x+DeltaX;
   Teil[a].y := Teil[a].y+DeltaY;
   END;
FOR a := 1 to 4 DO
   BEGIN
   P.x := 10+(Teil[a].x-1)*20;
   P.y := 10+(Teil[a].y-1)*20;
   CASE Teil[5].x OF
      1   : WinDrawBitmap(PS,RotBmp,nil,@P,0,0,dbm_Normal);
      2,3 : WinDrawBitmap(PS,GruenBmp,nil,@P,0,0,dbm_Normal);
      4,5 : WinDrawBitmap(PS,BlauBmp,nil,@P,0,0,dbm_Normal);
      6   : WinDrawBitmap(PS,GelbBmp,nil,@P,0,0,dbm_Normal);
      7   : WinDrawBitmap(PS,LilaBmp,nil,@P,0,0,dbm_Normal);
      END;
   END;
WinReleasePS(PS);
END;

PROCEDURE Aufsetzen;
VAR s : String[10];
    a : Byte;
    KoordX, KoordY : Byte;
    Y2 : Byte;
    Rec : Rectl;
    ReiheWeg : Boolean;
    PktStr, LevStr, Ausgabe : Array[0..255] of Char;
    PS : hPS;
    P : PointL;
    b : Array[0..255] of Char;

BEGIN
PS := WinGetPS(hwndClient);

CASE Teil[5].x OF
  1,4,5 : Inc(Punkte,8);
  2,3   : Inc(Punkte,10);
  6,7   : Inc(Punkte,5);
  END;

Str(Teil[5].x,s);
FOR a := 1 to 4 DO Feld[Teil[a].x,Teil[a].y] := s[1];

ReiheWeg := False;
KoordY := 1;
REPEAT
s := '';
FOR KoordX := 1 to 10 DO s := s+Feld[KoordX,KoordY];
IF Pos(' ',s) = 0 then
   BEGIN
   ReiheWeg := True;
   FOR a := 1 to 10 DO CASE s[a] OF
      '1','4','5' : Inc(Punkte,(8+CurrentSpeed));
      '2','3'     : Inc(Punkte,(10+CurrentSpeed));
      '6','7'     : Inc(Punkte,(5+CurrentSpeed));
      END;

   FOR Y2 := KoordY+1 to 20 DO
      FOR KoordX := 1 to 10 DO Feld[KoordX,Y2-1] := Feld[KoordX,Y2];
   Dec(KoordY);
   END;
Inc(KoordY);
UNTIL KoordY = 21;
IF ReiheWeg then DrawFeld(PS);

Str(Punkte,PktStr);
WinSetWindowText(WinWindowFromId(hwndClient,id_Score),PktStr);

Teil := Next;
Next := GetRandomTeil;
DrawNext(PS);

IF not MovePossible(0,0) then
   BEGIN
   WinStopTimer(habAnchor,hwndClient,id_Timer);
   GameOver := True;
   DrawNext(PS);
   Str(CurrentSpeed,LevStr);
   StrCopy(Ausgabe,'Das Spiel ist beendet.'#10#10'Sie haben es bis Level ');
   StrCat(Ausgabe,LevStr);
   StrCat(Ausgabe,' geschafft.'#10'Ihr Punktestand betr„gt ');
   StrCat(Ausgabe,PktStr);
   StrCat(Ausgabe,'.'#10#10);
   WinMessageBox(hwnd_Desktop,hwndClient,Ausgabe,'Bastisoft Tetris',-1,mb_Ok or mb_Warning);

   IF Punkte > HiScore[10].Score then
      BEGIN
      NameHolen;
      FOR a := 10 downto 1 DO IF HiScore[a].Score < Punkte then
         BEGIN
         IF a < 10 then HiScore[a+1] := HiScore[a];
         HiScore[a].Name := NewName;
         HiScore[a].Score := Punkte;
         END;
      END;
   END
ELSE MoveTeil(0,0);

Inc(Klicks);
IF (Klicks = 30) AND not GameOver then
   BEGIN
   Klicks := 0;
   Inc(CurrentSpeed);
   Str(CurrentSpeed,b);
   WinSetWindowText(WinWindowFromId(hwndClient,id_Curr),b);
   WinStopTimer(habAnchor,hwndClient,id_Timer);
   WinStartTimer(habAnchor,hwndClient,id_Timer,1000 div CurrentSpeed);
   END;

WinReleasePS(PS);
END;

PROCEDURE TimerReact;
BEGIN
IF MovePossible(0,-1) then MoveTeil(0,-1) ELSE Aufsetzen;
END;

PROCEDURE Drehen;
VAR PS : hPS;
    P : PointL;
    a : Byte;
    Temp : TTeil;
    Passt : Boolean;

PROCEDURE TeilLoeschen;
VAR b : Byte;
BEGIN
FOR b := 1 to 4 DO
   BEGIN
   MoveTo(PS,10+(Teil[b].x-1)*20,10+(Teil[b].y-1)*20);
   P.x := 10+Teil[b].x*20-1;
   P.y := 10+Teil[b].y*20-1;
   GpiBox(PS,dro_Fill,P,0,0);
   END;
END;

BEGIN
PS := WinGetPS(hwndClient);
GpiSetColor(PS,clr_Black);

Temp := Teil;
FOR a := 1 to 4 DO
   BEGIN
   Temp[a].x := Temp[a].x+Drehung[Teil[5].x][Teil[5].y][a].x;
   Temp[a].y := Temp[a].y+Drehung[Teil[5].x][Teil[5].y][a].y;
   END;
Passt := True;
FOR a := 1 to 4 DO IF (Feld[Temp[a].x,Temp[a].y] <> ' ') OR not (Temp[a].x IN [1..10]) OR not (Temp[a].y IN [1..20]) then Passt := False;
IF Passt then
   BEGIN
   TeilLoeschen;
   Teil := Temp;
   MoveTeil(0,0);
   Inc(Teil[5].y);
   IF Teil[5].y = 5 then Teil[5].y := 1;
   END;

WinReleasePS(PS);
END;

PROCEDURE Taste(vk : uShort);
VAR a : Integer;
    Rec : Rectl;
BEGIN
IF GameOver then EXIT;
CASE vk OF
   vk_Left : IF MovePossible(-1,0) AND not Pause AND not GameOver then MoveTeil(-1,0);
   vk_Right : IF MovePossible(1,0) AND not Pause AND not GameOver then MoveTeil(1,0);
   vk_Down : BEGIN
             a := 0;
             REPEAT
             Dec(a);
             UNTIL MovePossible(0,a) = False;
             MoveTeil(0,a+1);
             Aufsetzen;
             END;
   vk_Up : Drehen;
   END;
END;

PROCEDURE ResetGame;
VAR Rec : Rectl;
    PS : hPS;
    s : Array[0..255] of Char;
BEGIN
PS := WinGetPS(hwndClient);
IF not GameOver then WinStopTimer(habAnchor,hwndClient,id_Timer);

Punkte := 0;
WinSetWindowText(WinWindowFromId(hwndClient,id_Score),'0');
FillChar(Feld,SizeOf(Feld),' ');

GameOver := False;
IF Pause = True then WinSetWindowText(WinWindowFromId(hwndClient,id_Pause),'Pause');

Pause := False;
Next := GetRandomTeil;
Teil := GetRandomTeil;
DrawNext(PS);

CurrentSpeed := StartSpeed;
Str(CurrentSpeed,s);
WinSetWindowText(WinWindowFromId(hwndClient,id_Curr),s);
Klicks := 0;
WinStartTimer(habAnchor,hwndClient,id_Timer,1000 div CurrentSpeed);
DrawFeld(PS);
WinReleasePS(PS);
END;

PROCEDURE TogglePause;
BEGIN
IF GameOver then WinAlarm(hwnd_Desktop,wa_Error)
ELSE
   BEGIN
   IF Pause = True then
      BEGIN
      Pause := False;
      WinSetWindowText(WinWindowFromId(hwndClient,id_Pause),'Pause');
      WinStartTimer(habAnchor,hwndClient,id_Timer,1000 div CurrentSpeed);
      END
   ELSE
      BEGIN
      Pause := True;
      WinSetWindowText(WinWindowFromId(hwndClient,id_Pause),'Weiter');
      WinStopTimer(habAnchor,hwndClient,id_Timer);
      END;
   END;
END;

PROCEDURE ChangeStartSpeed(Dir : Integer);
VAR s : Array[0..255] of Char;
BEGIN
IF Dir = -1 then
   BEGIN
   IF StartSpeed > 1 then
      BEGIN
      Dec(StartSpeed);
      Str(StartSpeed,s);
      WinSetWindowText(WinWindowFromId(hwndClient,id_Speed),s);
      END
   ELSE WinAlarm(hwnd_Desktop,wa_Error);
   END
ELSE
   BEGIN
   IF StartSpeed < 20 then
      BEGIN
      Inc(StartSpeed);
      Str(StartSpeed,s);
      WinSetWindowText(WinWindowFromId(hwndClient,id_Speed),s);
      END
   ELSE WinAlarm(hwnd_Desktop,wa_Error);
   END;
END;

FUNCTION ClientWndProc(Window : hWnd; Msg : uLong; Mp1, Mp2 : MParam) : MResult; cdecl;
VAR PS : hPS;
BEGIN
CASE Msg OF
   wm_Timer : TimerReact;
   wm_Create : BEGIN
               ClientWndProc := WinDefWindowProc(Window,Msg,Mp1,Mp2);
               PS := WinGetPS(Window);
               RotBmp := GpiLoadBitmap(PS,0,id_Rot,0,0);
               GruenBmp := GpiLoadBitmap(PS,0,id_Gruen,0,0);
               BlauBmp := GpiLoadBitmap(PS,0,id_Blau,0,0);
               GelbBmp := GpiLoadBitmap(PS,0,id_Gelb,0,0);
               LilaBmp := GpiLoadBitmap(PS,0,id_Lila,0,0);
               WinReleasePS(PS);
               END;
   wm_Paint : BEGIN
              PS := WinBeginPaint(Window,0,nil);
              Zeichnen(PS);
              WinEndPaint(PS);
              END;
   wm_Size : BEGIN
             Groesse.X := Short1FromMp(Mp2);
             Groesse.Y := Short2FromMp(Mp2);
             END;
   wm_Command : BEGIN
                CASE LongFromMp(Mp1) OF
                   id_Reset : ResetGame;
                   id_Pause : TogglePause;
                   id_Ende : WinPostMsg(Window,wm_Close,0,0);
                   id_Rechts : ChangeStartSpeed(1);
                   id_Links : ChangeStartSpeed(-1);
                   id_HiScore : ShowHiScore;
                   END;
                END;
   wm_Char : BEGIN
             IF Short1FromMp(Mp1) AND kc_KeyUp = 0 then
                BEGIN
                IF Short1FromMp(Mp1) AND kc_VirtualKey = kc_VirtualKey then Taste(Short2FromMp(Mp2));
                IF Short1FromMp(Mp1) AND kc_Char = kc_Char then
                   BEGIN
                   CASE Short1FromMp(Mp2) OF
                      ord('v') : WinMessageBox(hwnd_Desktop,hwndClient,'Bastisoft Tetris'#10'Version '+
                                 VerNum+#10'Copyright 1997 by Bastisoft','Versions-Info',-1,mb_Ok or mb_Information);
                      ord('p') : TogglePause;
                      ord('q') : WinPostMsg(Window,wm_Close,0,0);
                      ord('h') : ShowHiScore;
                      ord('n') : ResetGame;
                      ord('+') : ChangeStartSpeed(1);
                      ord('-') : ChangeStartSpeed(-1);
                      END;
                   END;
                END;
             END;
   wm_Close : BEGIN
              IF WinMessageBox(hwnd_Desktop,hwndClient,'Wollen Sie Bastisoft Tetris wirklich beenden?','Moment mal...',-1,mb_YesNo or mb_IconQuestion)
              = mbid_Yes then WinPostMsg(Window,wm_Quit,0,0);
              END;
   wm_Quit : BEGIN
             GpiDeleteBitmap(RotBmp);
             GpiDeleteBitmap(GruenBmp);
             GpiDeleteBitmap(BlauBmp);
             GpiDeleteBitmap(GelbBmp);
             GpiDeleteBitmap(LilaBmp);

             IF not GameOver then WinStopTimer(habAnchor,hwndClient,id_Timer);

             ClientWndProc := WinDefWindowProc(Window,Msg,Mp1,Mp2);
             END;
   ELSE ClientWndProc := WinDefWindowProc(Window,Msg,Mp1,Mp2);
   END;
END;

PROCEDURE InitVars;
VAR a, a2 : Byte;
    f : File;
    b, b2 : Byte;
    c : Char;
    i : Integer;
BEGIN
RANDOMIZE;
FillChar(Feld,SizeOf(Feld),' ');
GameOver := True;
StartSpeed := 5;
NewName := '';

FOR a := 1 to 10 DO WITH HiScore[a] DO
   BEGIN
   Name := '[Frei]';
   Score := 5500 - a * 500;
   END;

Assign(f,'hiscore.dat');
{$I-}
Reset(f,1);
IF IoResult = 0 then
   BEGIN
   FOR a := 1 to 10 DO
      BEGIN
      BlockRead(f,b,1);
      HiScore[a].Name := '';
      FOR a2 := 1 to b DO
         BEGIN
         BlockRead(f,b2,1);
         c := chr(b2 - 55);
         HiScore[a].Name := HiScore[a].Name + c;
         END;
      BlockRead(f,HiScore[a].Score,SizeOf(LongInt));
      END;
   BlockRead(f,StartSpeed,SizeOf(LongInt));
   Close(f);
   END;
{$I+}

SmallFont := False;
FOR i := 1 to ParamCount DO IF ParamStr(i) = '-s' then SmallFont := True;
END;

PROCEDURE SaveAgain;
VAR f : File;
    a, b, b2 : Byte;
    c : Char;
BEGIN
Assign(f,'hiscore.dat');
{$I-}
Rewrite(f,1);
IF IoResult = 0 then
   BEGIN
   FOR a := 1 to 10 DO
      BEGIN
      b := Lo(Length(HiScore[a].Name));
      BlockWrite(f,b,1);
      FOR b2 := 1 to Length(HiScore[a].Name) DO
         BEGIN
         b := ord(HiScore[a].Name[b2]);
         c := chr(b+55);
         BlockWrite(f,c,1);
         END;
      BlockWrite(f,HiScore[a].Score,SizeOf(LongInt));
      END;
   BlockWrite(f,StartSpeed,SizeOf(LongInt));
   Close(f);
   END;
{$I+}
END;

BEGIN
InitVars;

habAnchor := WinInitialize(0);
hmqQueue := WinCreateMsgQueue(habAnchor,0);
WinRegisterClass(habAnchor,'BastisoftClass',ClientWndProc,cs_SizeRedraw or cs_HitTest,0);
hwndFrame := WinCreateStdWindow(hwnd_Desktop,ws_Visible,WinFlags,'BastisoftClass',Titel,ws_Visible,0,id_Icon,@hwndClient);
WinSetWindowPos(hwndFrame,0,150,100,348,448,swp_Size or swp_Move or swp_Activate or swp_Show);
Farbe.bRed := 204;
Farbe.bBlue := 204;
Farbe.bGreen := 204;
Farbe.fcOptions := 0;
WinSetPresParam(hwndClient,pp_BackgroundColor,SizeOf(Farbe),@Farbe);

IF SmallFont then
   BEGIN
   StrCopy(WinFont,'8.Helv');
   WinSetPresParam(hwndClient,pp_FontNameSize,SizeOf(WinFont),@WinFont);
   END;

WinCreateWindow(hwndClient,wc_Button,'Neues Spiel',ws_Visible or bs_PushButton or bs_NoPointerFocus,225,94,105,26,hwndClient,hwnd_Top,id_Reset,nil,nil);
WinCreateWindow(hwndClient,wc_Button,'Pause',ws_Visible or bs_PushButton or bs_NoPointerFocus,225,65,105,26,hwndClient,hwnd_Top,id_Pause,nil,nil);
WinCreateWindow(hwndClient,wc_Button,'Hi-Scores',ws_Visible or bs_PushButton or bs_NoPointerFocus,225,36,105,26,hwndClient,hwnd_Top,id_HiScore,nil,nil);
WinCreateWindow(hwndClient,wc_Button,'Beenden',ws_Visible or bs_PushButton or bs_NoPointerFocus,225,7,105,26,hwndClient,hwnd_Top,id_Ende,nil,nil);
WinCreateWindow(hwndClient,wc_Static,'Level:',ws_Visible or ss_Text,225,191,40,20,hwndClient,hwnd_Top,-1,nil,nil);
WinCreateWindow(hwndClient,wc_Static,'',ws_Visible or ss_Text,268,191,62,20,hwndClient,hwnd_Top,id_Curr,nil,nil);
WinCreateWindow(hwndClient,wc_Static,'Startlevel:',ws_Visible or ss_Text,225,160,105,20,hwndClient,hwnd_Top,-1,nil,nil);
WinCreateWindow(hwndClient,wc_Static,'',ws_Visible or ss_Text or dt_Center,250,133,20,20,hwndClient,hwnd_Top,id_Speed,nil,nil);
WinCreateWindow(hwndClient,wc_Button,'#106',ws_Visible or bs_PushButton or bs_NoPointerFocus or bs_Bitmap,225,134,20,21,hwndClient,hwnd_Top,id_Links,nil,nil);
WinCreateWindow(hwndClient,wc_Button,'#107',ws_Visible or bs_PushButton or bs_NoPointerFocus or bs_Bitmap,275,134,20,21,hwndClient,hwnd_Top,id_Rechts,nil,nil);
WinCreateWindow(hwndClient,wc_Static,'Punkte:',ws_Visible or ss_Text,225,220,50,20,hwndClient,hwnd_Top,id_Score,nil,nil);
WinCreateWindow(hwndClient,wc_Static,'0',ws_Visible or ss_Text,275,220,55,20,hwndClient,hwnd_Top,id_Score,nil,nil);
WinCreateWindow(hwndClient,wc_Static,'N„chstes Teil:',ws_Visible or ss_Text,225,392,105,20,hwndClient,hwnd_Top,-1,nil,nil);

Str(StartSpeed,SpeedString);
WinSetWindowText(WinWindowFromId(hwndClient,id_Speed),SpeedString);

WHILE WinGetMsg(habAnchor,qmMsg,0,0,0) DO WinDispatchMsg(habAnchor,qmMsg);

WinDestroyWindow(hwndFrame);
WinDestroyMsgQueue(hmqQueue);
WinTerminate(habAnchor);

SaveAgain;
END.
