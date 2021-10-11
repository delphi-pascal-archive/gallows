program Pendu;

uses
  Forms,
  Main in 'Main.pas' {Form1};

{$R *.RES}
{$R WindowsXP.res}

begin
  Application.Initialize;
  Application.Title := 'Pendu';
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
