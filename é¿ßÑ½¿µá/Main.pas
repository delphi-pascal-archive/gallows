unit Main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Grids, JPEG;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    ListBox1: TListBox;
    GroupBox1: TGroupBox;
    Pic: TImage;
    State: TImage;
    Shape1: TShape;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    Button8: TButton;
    Button9: TButton;
    Button10: TButton;
    Button11: TButton;
    Button12: TButton;
    Button13: TButton;
    Button14: TButton;
    Button15: TButton;
    Button16: TButton;
    Button17: TButton;
    Button18: TButton;
    Button19: TButton;
    Button20: TButton;
    Button21: TButton;
    Button22: TButton;
    Button23: TButton;
    Button24: TButton;
    Button25: TButton;
    Button26: TButton;
    Button27: TButton;
    Button28: TButton;
    Button29: TButton;
    WState: TStringGrid;
    GroupBox2: TGroupBox;
    Label1: TLabel;
    DeadGame: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Bevel2: TBevel;
    Shape2: TShape;
    Label4: TLabel;
    Label5: TLabel;
    Button30: TButton;
    Bevel1: TBevel;
    procedure Button3Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    function GetWord: String;
    procedure Button1Click(Sender: TObject);
    procedure UpdateSize;
    procedure GetChar(C: Char);
    procedure InitializeGame;
    procedure UpdateImg;
    procedure Win;
    procedure Lose;
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure Button11Click(Sender: TObject);
    procedure Button12Click(Sender: TObject);
    procedure Button13Click(Sender: TObject);
    procedure Button14Click(Sender: TObject);
    procedure Button15Click(Sender: TObject);
    procedure Button16Click(Sender: TObject);
    procedure Button17Click(Sender: TObject);
    procedure Button18Click(Sender: TObject);
    procedure Button19Click(Sender: TObject);
    procedure Button20Click(Sender: TObject);
    procedure Button21Click(Sender: TObject);
    procedure Button22Click(Sender: TObject);
    procedure Button23Click(Sender: TObject);
    procedure Button24Click(Sender: TObject);
    procedure Button25Click(Sender: TObject);
    procedure Button26Click(Sender: TObject);
    procedure Button27Click(Sender: TObject);
    procedure Button28Click(Sender: TObject);
    procedure Button29Click(Sender: TObject);
    procedure ShowWord;
    procedure RecupList;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button30Click(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  Form1: TForm1;
  UsedWord: String;
  LifeState: ShortInt;
  Dirr: String;

implementation

{$R *.DFM}

procedure TForm1.RecupList;     // Procédure pour la récuperation de la liste de mots
begin
     ListBox1.Items.Clear;   // On nettoie (en cas d'artéfacts eventuels)
     ListBox1.Items.Add('animal');
     ListBox1.Items.Add('mollusque');
     ListBox1.Items.Add('roulette');
     ListBox1.Items.Add('zebre');        // On ajoute des mots (on peut en mettre plus !)
     ListBox1.Items.Add('balle');
     ListBox1.Items.Add('yoyo');
     ListBox1.Items.Add('manger');
     ListBox1.Items.SaveToFile(Dirr + 'ListeMots.txt');   // On sauve
     Label3.Caption := IntToStr(ListBox1.Items.Count);   // On update le label d'indication
end;

procedure TForm1.ShowWord;  // Procédure pour afficher le mot complètement si on a perdu
Var
   I: Integer;
begin
     for I := 1 to Length(UsedWord) do
     begin
          WState.Cells[I - 1, 0] := UsedWord[I];
     end;
end;

procedure TForm1.Win;     // Procédure (quand on gagne)
begin
     MessageDlg('Bravo ! Vous avez trouvé le mot !', mtInformation, [mbOK], 0);
     Panel2.Enabled := False;
     panel3.Enabled := False;
     DeadGame.Visible := True;
     Label1.Visible := False;
end;

procedure TForm1.Lose;  // Procédure quand on perd
begin
     ShowWord;
     MessageDlg('Vous n''avez pas trouvé le mot ... Vous avez perdu ! Le mot va s''afficher ...', mtInformation, [mbOK], 0);
     Panel2.Enabled := False;
     panel3.Enabled := False;
     DeadGame.Visible := True;
     Label1.Visible := False;
end;


procedure TForm1.InitializeGame;  // Initialisation du jeu
begin
     Panel2.Enabled := True;
     panel3.Enabled := True;
     if FileExists(Dirr + 'ListeMots.txt') = True then ListBox1.Items.LoadFromFile(Dirr + 'ListeMots.txt') else RecupList;   // Voir si la liste existe, et sinon on récupère
     Button4.Enabled := True;
     Button5.Enabled := True;
     Button6.Enabled := True;
     Button7.Enabled := True;
     Button8.Enabled := True;
     Button9.Enabled := True;
     Button10.Enabled := True;
     Button11.Enabled := True;
     Button12.Enabled := True;
     Button13.Enabled := True;           // Activation de tous les boutons
     Button14.Enabled := True;
     Button15.Enabled := True;
     Button16.Enabled := True;
     Button17.Enabled := True;
     Button18.Enabled := True;
     Button19.Enabled := True;
     Button20.Enabled := True;
     Button21.Enabled := True;
     Button22.Enabled := True;
     Button23.Enabled := True;
     Button24.Enabled := True;
     Button25.Enabled := True;
     Button26.Enabled := True;
     Button27.Enabled := True;
     Button28.Enabled := True;
     Button29.Enabled := True;
     LifeState := 0;   // On initialise le nombre de vies
     UsedWord := '';  // On initialise le mot
end;

procedure TForm1.UpdateImg;   // Mise a jour de l'image (appelée après chaque clic de bouton)
Var
   I:integer;
   WinW: String;
begin
     WinW := '';                                  // On vérifie la présence de l'image, si elle est la on l'affiche, sinon on ferme le programme -_-
     if FileExists(Dirr + 'Images\Pendu_' + IntToStr(LifeState + 1) + '.jpg') = True then State.Picture.LoadFromFile(Dirr + 'Images\Pendu_' + IntToStr(LifeState + 1) + '.jpg') else begin MessageDlg('Erreur : le fichier image n''a pas été trouvé. Le pendu va maintenant se fermer.', mtError, [mbOk], 0); Application.Terminate; end;
     if LifeState = 9 then Lose;
     for I := 0 to Length(usedword) - 1 do
begin
     WinW := WinW + WState.Cells[I, 0];
end;
     if (UpperCase(WinW) = UpperCase(UsedWord)) and (LifeState < 9) then Win;
     Label1.Caption := 'Remained attempts: ' + IntToStr(10 - (LifeState + 1)) + '.';
end;

procedure TForm1.GetChar(C:Char);   // Procédure qui scanne le mot et qui ajoute le caractère C, si il est dans le mot
Var
   I: Integer;
   GotIt: Boolean;
begin
     GotIt := False;
     for I := 1 to Length(usedWord) do  // On scanne le mot
begin
     if UpperCase(usedWord[I]) = UpperCase(C) then begin WState.Cells[I - 1, 0] := C; GotIt := True; end;   // GotIt := True si on l'a trouvé
end;
    if GotIt = False then LifeState := LifeState + 1;  // Si on ne l'a pas trouvé, on ajoute 1 au status de vie x)
end;


procedure TForm1.UpdateSize;   // Procédure qui regarde la taille du mot et qui adapte la grille en fonction
Var
   I: Integer;
begin
     WState.ColCount := Length(UsedWord); // On demande autant de colonnes que de caractères dans le mot
     for I := 0 to Length(UsedWord) do
begin
     WState.Cells[I, 0] := '...';  // On ajoute '...' à chaque caractère non trouvé !
end;

end;


function TForm1.GetWord: String;   // Fonction qui récupère un mot au hasard dans la liste
Var
   R: Integer;
begin
     randomize;
     R := random(ListBox1.Items.Count - 1) + 1;
     Result := ListBox1.Items.Strings[R];
end;

procedure TForm1.Button3Click(Sender: TObject);  // Quand on quitte
begin
 Application.Terminate;
end;

procedure TForm1.Button2Click(Sender: TObject);   // Quand on ajoute du code
Var
   Mot: String;
begin                            // On fait un InputQuery
     MessageDlg('Les mots de plus de 10 lettres et de moins de 3 lettres ne seront pas pris en compte.', mtWarning, [mbOK], 0);
     if InputQuery('Ajouter un mot', 'Entrez le mot à ajouter à la liste : ', Mot) = True then
begin
     if (Length(Mot) > 2) and (Length(Mot) < 10) then   // On verifie la taille
     begin
     ListBox1.Items.Add(Mot);  // On ajoute le mot
     ListBox1.Sorted := False;   // Facultatif : on sorte la listebox
     ListBox1.Sorted := True;    // Pareil
     ListBox1.Items.SaveToFile(Dirr + 'ListeMots.txt'); // On sauve
     Label3.Caption := IntToStr(ListBox1.Items.Count);  // On adapte le label d'indication
     end;
end;

end;

procedure TForm1.FormCreate(Sender: TObject); // Création de la form
begin
     Dirr := ExtractFilePath(Application.ExeName);  // On extracte le chemin du dossier de jeu
     if FileExists(Dirr + 'Images\Pendu_1.jpg') = False then begin MessageDlg('Erreur : image non trouvée !', mtError, [mbOK], 0); Application.Terminate; end;
     if FileExists(Dirr + 'Images\Pendu_2.jpg') = False then begin MessageDlg('Erreur : image non trouvée !', mtError, [mbOK], 0); Application.Terminate; end;
     if FileExists(Dirr + 'Images\Pendu_3.jpg') = False then begin MessageDlg('Erreur : image non trouvée !', mtError, [mbOK], 0); Application.Terminate; end;      // Bloc qui vérifie les images
     if FileExists(Dirr + 'Images\Pendu_4.jpg') = False then begin MessageDlg('Erreur : image non trouvée !', mtError, [mbOK], 0); Application.Terminate; end;
     if FileExists(Dirr + 'Images\Pendu_5.jpg') = False then begin MessageDlg('Erreur : image non trouvée !', mtError, [mbOK], 0); Application.Terminate; end;
     if FileExists(Dirr + 'Images\Pendu_6.jpg') = False then begin MessageDlg('Erreur : image non trouvée !', mtError, [mbOK], 0); Application.Terminate; end;
     if FileExists(Dirr + 'Images\Pendu_7.jpg') = False then begin MessageDlg('Erreur : image non trouvée !', mtError, [mbOK], 0); Application.Terminate; end;
     if FileExists(Dirr + 'Images\Pendu_8.jpg') = False then begin MessageDlg('Erreur : image non trouvée !', mtError, [mbOK], 0); Application.Terminate; end;
     if FileExists(Dirr + 'Images\Pendu_9.jpg') = False then begin MessageDlg('Erreur : image non trouvée !', mtError, [mbOK], 0); Application.Terminate; end;
     if FileExists(Dirr + 'Images\Pendu_10.jpg') = False then begin MessageDlg('Erreur : image non trouvée !', mtError, [mbOK], 0); Application.Terminate; end;
     Form1.activeControl := Button1;   // On donne la focalisation au bouton 'Nouvelle partie'
     InitializeGame;    // On initialise le jeu pour la première fois (aucune partie ne sera démarrée)
     Panel2.Enabled := False;
     Panel3.Enabled := False;
     Label1.Visible := False;
     Label3.Caption := IntToStr(ListBox1.Items.Count);
     if FileExists(Dirr + 'Images\Pendu.jpg') = True then Pic.Picture.LoadFromFile(Dirr + 'Images\Pendu.jpg') else Label4.Visible := True;   // Si l'image en couleurs existe, on l'affiche, sinon on montre un label "Image non trouvée"
end;

procedure TForm1.Button1Click(Sender: TObject);   // Bouton "Nouvelle partie"
begin
     Label5.Visible := False; // On fait disparaître le label (Aucune partie en cours) à la place des images de jeu
     InitializeGame;   // On initialise une partie
     UsedWord := GetWord;   // On récupère un mot au hasard
     UpdateSize;    // On adapte la taille de la grille selon UsedWord
     UpdateImg;   // On affiche les images de jeu
     DeadGame.Visible := False;  // On fait disparaître le label "Aucune partie en cours"
     Label1.Visible := True;  // On affiche le label "Tentatives Restantes : X"
end;


////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
/////          Le code suivant concerne tous les boutons, pour choisir un caractère            /////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////


procedure TForm1.Button4Click(Sender: TObject);
begin
     Button4.Enabled := False;
     GetChar('a');
     UpdateImg;
end;

procedure TForm1.Button5Click(Sender: TObject);
begin
     Button5.Enabled := False;
     GetChar('b');
     UpdateImg;
end;

procedure TForm1.Button6Click(Sender: TObject);
begin
     Button6.Enabled := False;
     GetChar('c');
     UpdateImg;
end;

procedure TForm1.Button7Click(Sender: TObject);
begin
     Button7.Enabled := False;
     GetChar('d');
     UpdateImg;
end;

procedure TForm1.Button8Click(Sender: TObject);
begin
     Button8.Enabled := False;
     GetChar('e');
     UpdateImg;
end;

procedure TForm1.Button9Click(Sender: TObject);
begin
     Button9.Enabled := False;
     GetChar('f');
     UpdateImg;
end;

procedure TForm1.Button10Click(Sender: TObject);
begin
     Button10.Enabled := False;
     GetChar('g');
     UpdateImg;
end;

procedure TForm1.Button11Click(Sender: TObject);
begin
     Button11.Enabled := False;
     GetChar('h');
     UpdateImg;
end;

procedure TForm1.Button12Click(Sender: TObject);
begin
     Button12.Enabled := False;
     GetChar('i');
     UpdateImg;
end;

procedure TForm1.Button13Click(Sender: TObject);
begin
     Button13.Enabled := False;
     GetChar('j');
     UpdateImg;
end;

procedure TForm1.Button14Click(Sender: TObject);
begin
     Button14.Enabled := False;
     GetChar('k');
     UpdateImg;
end;

procedure TForm1.Button15Click(Sender: TObject);
begin
     Button15.Enabled := False;
     GetChar('l');
     UpdateImg;
end;

procedure TForm1.Button16Click(Sender: TObject);
begin
     Button16.Enabled := False;
     GetChar('m');
     UpdateImg;
end;

procedure TForm1.Button17Click(Sender: TObject);
begin
     Button17.Enabled := False;
     GetChar('n');
     UpdateImg;
end;

procedure TForm1.Button18Click(Sender: TObject);
begin
     Button18.Enabled := False;
     GetChar('o');
     UpdateImg;
end;

procedure TForm1.Button19Click(Sender: TObject);
begin
     Button19.Enabled := False;
     GetChar('p');
     UpdateImg;
end;

procedure TForm1.Button20Click(Sender: TObject);
begin
     Button20.Enabled := False;
     GetChar('q');
     UpdateImg;
end;

procedure TForm1.Button21Click(Sender: TObject);
begin
     Button21.Enabled := False;
     GetChar('r');
     UpdateImg;
end;

procedure TForm1.Button22Click(Sender: TObject);
begin
     Button22.Enabled := False;
     GetChar('s');
     UpdateImg;
end;

procedure TForm1.Button23Click(Sender: TObject);
begin
     Button23.Enabled := False;
     GetChar('t');
     UpdateImg;
end;

procedure TForm1.Button24Click(Sender: TObject);
begin
     Button24.Enabled := False;
     GetChar('u');
     UpdateImg;
end;

procedure TForm1.Button25Click(Sender: TObject);
begin
     Button25.Enabled := False;
     GetChar('v');
     UpdateImg;
end;

procedure TForm1.Button26Click(Sender: TObject);
begin
     Button26.Enabled := False;
     GetChar('w');
     UpdateImg;
end;

procedure TForm1.Button27Click(Sender: TObject);
begin
     Button27.Enabled := False;
     GetChar('x');
     UpdateImg;
end;

procedure TForm1.Button28Click(Sender: TObject);
begin
     Button28.Enabled := False;
     GetChar('y');
     UpdateImg;
end;

procedure TForm1.Button29Click(Sender: TObject);
begin
     Button29.Enabled := False;
     GetChar('z');
     UpdateImg;
end;

// Petite procédure égarée, parmi les boutons :)

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);  // Clic sur la croix de la form !
begin
 Application.Terminate;
end;


procedure TForm1.Button30Click(Sender: TObject);  // Partie ou l'on peut choisir le mot (pour un jeu à 2 par exemple)
Var
   S: String;
begin
     MessageDlg('Les mots de plus de 10 lettres et de moins de 3 lettres ne seront pas pris en compte.', mtWarning, [mbOK], 0);  // On avertit l'utilisateur
     if InputQuery('Choix du mot', 'Entrez le mot à utiliser pour jouer :', S) then    // On demande un mot
     begin
          if Length(S) < 4 then begin MessageDlg('Votre mot fait moins de 3 lettres ! Veuillez entrer un nouveau mot.', mtError, [mbOk], 0); Exit; end;  // On vérifie la taille
          if Length(S) > 10 then begin MessageDlg('Votre mot dépasse 10 lettres ! Veuillez entrer un nouveau mot.', mtError, [mbOk], 0); Exit; end;    // Pareil
          if (Length(S) < 11) and (Length(S) > 3) then  // Si la taille est correcte alors ...
          begin
          if MessageDlg('Voulez-vous ajouter ce mot à la liste ?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then begin ListBox1.Items.Add(S); ListBox1.Sorted := False; ListBox1.Sorted := True; ListBox1.Items.SaveToFile(Dirr + 'ListeMots.txt'); Label3.Caption := IntToStr(ListBox1.Items.Count); end; // On demande si il veut ajouter le mot à la liste
          Label5.Visible := False; // On fait disparaître le label (Aucune partie en cours) à la place des images de jeu
          InitializeGame;   // On initialise une partie
          UsedWord := S;   // On récupère le mot choisi par S
          UpdateSize;    // On adapte la taille de la grille selon le mot choisi
          UpdateImg;   // On affiche les images de jeu
          DeadGame.Visible := False;  // On fait disparaître le label "Aucune partie en cours"
          Label1.Visible := True;  // On affiche le label "Tentatives Restantes : X"
          end;
     end;
end;

end.
