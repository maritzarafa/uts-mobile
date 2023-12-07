unit Unit1;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants, System.IniFiles, System.IOUtils,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.TabControl,
  FMX.Memo.Types, FMX.StdCtrls, FMX.ScrollBox, FMX.Memo,
  FMX.Controls.Presentation, System.Actions, FMX.ActnList, FMX.ListView.Types,
  FMX.ListView.Appearances, FMX.ListView.Adapters.Base, FMX.ListView;

type
  TForm1 = class(TForm)
    TabControl1: TTabControl;
    TabItem1: TTabItem;
    TabItem2: TTabItem;
    Memo2: TMemo;
    ToolBar1: TToolBar;
    Button2: TButton;
    Button1: TButton;
    ActionList1: TActionList;
    Simpan: TAction;
    Baca: TAction;
    ListView1: TListView;
    procedure FormShow(Sender: TObject);
    procedure SimpanExecute(Sender: TObject);
    procedure BacaExecute(Sender: TObject);
    procedure ListView1ItemClick(const Sender: TObject; const AItem: TListViewItem);
  private
    { Private declarations }
    PathFile: string;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

procedure TForm1.BacaExecute(Sender: TObject);
var
  LItem: TListViewItem;
  LocalFile: TIniFile;
  Notes: string;
  Created: string;
begin
  Pathfile := TPath.Combine(TPath.GetDocumentsPath, 'Notes.ini');
  try
    ListView1.Items.Clear; // Clear existing items

    LocalFile := TIniFile.Create(PathFile);

    Created := LocalFile.ReadString('Catatan', 'Created', '');
    Notes := LocalFile.ReadString('Catatan', 'Notes', '');

    LItem := ListView1.Items.Add;
    LItem.Text := Notes;
    LItem.Detail := Created;
  finally
    FreeAndNil(LocalFile);
  end;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  Pathfile := TPath.Combine(TPath.GetDocumentsPath, 'Notes.ini');
end;

procedure TForm1.SimpanExecute(Sender: TObject);
var
  LocalFile: TIniFile;
  Created: TDateTime;
  FormattedDate: string;
begin
  try
    Pathfile := TPath.Combine(TPath.GetDocumentsPath, 'Notes.ini');
    // Check if the PathFile is a valid path
    if FileExists(PathFile) then
      LocalFile := TIniFile.Create(PathFile)
    else
      LocalFile := TIniFile.Create(PathFile);

    try
      with LocalFile do
      begin
        Created := Now;
        FormattedDate := FormatDateTime('dd/mm/yyyy hh:nn:ss', Created);
        WriteString('Catatan', 'Created', FormattedDate);
        WriteString('Catatan', 'Notes', Memo2.Lines.Text);
      end;

      ShowMessage('Notes Saved');

      // Update ListView with the new note
      BacaExecute(Sender);

      // Clear Memo after saving
      Memo2.Lines.Clear;
    except
      on E: Exception do
      begin
        // Handle exceptions here
        ShowMessage('Error saving notes: ' + E.Message);
      end;
    end;
  finally
    // Make sure to free the LocalFile object
    FreeAndNil(LocalFile);
  end;
end;

procedure TForm1.ListView1ItemClick(const Sender: TObject; const AItem: TListViewItem);
begin
  ShowMessage(AItem.Text + #13#10 + AItem.Detail );
end;
end.
