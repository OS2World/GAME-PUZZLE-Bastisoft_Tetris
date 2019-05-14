{
    Highscore editor for Bastisoft Tetris for OS/2
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

PROGRAM HSE; { Hiscore Editor fr Bastisoft Tetris }

{$PMTYPE VIO}

USES Use32, Crt;

VAR f : File;
    b, b2 : Byte;
    c : Char;
    i, i2 : Byte;
    HiScore : Array[1..10] of RECORD
                              Name : String;
                              Score : LongInt;
                              END;
    l : LongInt;
    Startlevel : LongInt;
    NewName : String;
    NewScore : LongInt;

BEGIN
FOR i := 1 to 10 DO WITH HiScore[i] DO
   BEGIN
   Name := '';
   Score := 0;
   END;

Assign(f,'hiscore.dat');
Reset(f,1);
FOR i := 1 to 10 DO
   BEGIN
   BlockRead(f,b,1);
   FOR i2 := 1 to b DO
      BEGIN
      BlockRead(f,b2,1);
      c := chr(b2 - 55);
      HiScore[i].Name := HiScore[i].Name + c;
      END;
   BlockRead(f,HiScore[i].Score,SizeOf(LongInt));
   END;
BlockRead(f,Startlevel,SizeOf(LongInt));
Close(f);

c := #0;

WHILE not (c = 'q') DO
   BEGIN
   ClrScr;
   Writeln('Tetris HiScores:');
   Writeln;
   FOR i := 1 to 10 DO
      BEGIN
      Write(' ',i:2,HiScore[i].Name:30,'   ');
      Writeln(HiScore[i].Score);
      END;
   Writeln;
   Write('> ');
   REPEAT c := ReadKey; UNTIL c IN ['0'..'9','q','s','S','i'];
   WHILE KeyPressed DO c := ReadKey;
   Writeln(c);
   Writeln;
   Val(c,i,l);
   IF l = 0 then
      BEGIN
      IF i = 0 then i := 10;
      Write('New name: ');
      Readln(HiScore[i].Name);
      Write('New score: ');
      Readln(HiScore[i].Score);
      END;
   IF c = 's' then
      BEGIN
      Writeln('Current start speed is: ',Startlevel);
      Readkey;
      END;
   IF c = 'S' then
      BEGIN
      Write('New start speed: ');
      Readln(Startlevel);
      END;
   IF c = 'i' then
      BEGIN
      Write('New name: ');
      Readln(NewName);
      Write('New score: ');
      Readln(NewScore);
      IF NewScore <= HiScore[10].Score then Writeln('Score too low, not inserted!')
      ELSE
         BEGIN
         FOR i := 10 downto 1 DO IF HiScore[i].Score < NewScore then
            BEGIN
            IF i < 10 then HiScore[i+1] := HiScore[i];
            HiScore[i].Name := NewName;
            HiScore[i].Score := NewScore;
            END;
         END;
      END;
   END;

Rewrite(f,1);
FOR i := 1 to 10 DO
   BEGIN
   b := Lo(Length(HiScore[i].Name));
   BlockWrite(f,b,1);
   FOR i2 := 1 to Length(HiScore[i].Name) DO
      BEGIN
      b := ord(HiScore[i].Name[i2]);
      c := chr(b+55);
      BlockWrite(f,c,1);
      END;
   BlockWrite(f,HiScore[i].Score,SizeOf(LongInt));
   END;
BlockWrite(f,Startlevel,SizeOf(LongInt));
Close(f);

ClrScr;
Writeln('Copyright 1997 by Bastisoft');
END.
