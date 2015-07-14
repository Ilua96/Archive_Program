{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes, SysUtils, CustApp, crt, UCompress;

type
  { TMyApplication }
  TMyApplication = class(TCustomApplication)
  protected
    procedure DoRun; override;
  public
    constructor Create(TheOwner: TComponent); override;
    destructor Destroy; override;
    procedure WriteHelp; virtual;
    procedure ReadFile(Path: String);
    procedure WriteFile(Path: String);
  private
    Buf: array [0..2048] of Byte;
  end;

  const NewFileName = 2;
  const FilePath = 3;

{ TMyApplication }

procedure TMyApplication.DoRun;
var
  ErrorMsg: String;
begin
  ErrorMsg := CheckOptions('h a e c','help add extract create');
  if ErrorMsg <> '' then
  begin
    ShowException(Exception.Create(ErrorMsg));
    Terminate;
    Exit;
  end;

  if HasOption('c', 'create') then
  begin
    ReadFile(ParamStr(FilePath));
    Terminate;
    Exit;
  end;
  if HasOption('a', 'add') then
  begin
    ReadFile(ParamStr(FilePath));
    Terminate;
    Exit;
  end;
  if HasOption('e', 'extract') then
  begin
    Write('data extracted to ... ');
    Terminate;
    Exit;
  end;
  if HasOption('h', 'help') then
  begin
    WriteHelp;
    Terminate;
    Exit;
  end;

  WriteHelp;
  Terminate;
end;

constructor TMyApplication.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
  StopOnException := True;
end;

destructor TMyApplication.Destroy;
begin
  inherited Destroy;
end;

procedure TMyApplication.WriteHelp;
begin
  write('Welcome to program for archive and compress files' + LineEnding
       + 'Developers:' + LineEnding
       + '-Zhikhareva A.' + LineEnding
       + '-Lipov I.' + LineEnding
       + '-Trofimova O.' + LineEnding
       + LineEnding
       + 'Commands:' + LineEnding
       + '-c [New Archive Name] [Path to file] - create new archive' + LineEnding
       + '-a [Archive] [Path to file] - add to archive' + LineEnding
       + '-e [Archive] [Path to extract] - extract files' + LineEnding
       + '-h - help');
end;

procedure TMyApplication.ReadFile(Path: String);
var
  fi: File;
  NumRead: Word;
  i: integer = 0;
begin
  AssignFile(fi, Path);
  reset(fi, 1);
  repeat
    BlockRead(fi, Buf, SizeOf(Buf), NumRead);
  until (NumRead = 0);
  CloseFile(fi);
end;

procedure TMyApplication.WriteFile(Path: String);
var
  fo: File;
  NumWrite: Word;
begin
  //AssignFile(fo, Path);
  //Rewrite(fo, 1);
  //repeat
  //  BlockWrite(fo, Buf, SizeOf(Buf), NumWrite);
  //until NumWrite = 0;
  //CloseFile(fo);
end;

var
  Application: TMyApplication;

begin
  Application := TMyApplication.Create(nil);
  Application.Title := 'Archive Program';
  Application.Run;
  Application.Free;
end.
