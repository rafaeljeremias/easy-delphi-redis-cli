unit Providers.Caching;

interface

uses
  System.JSON,
  Redis.Client,
  Redis.Values,
  Redis.Commons,
  System.Classes,
  System.StrUtils,
  System.SysUtils,
  Redis.NetLib.Indy,
  Providers.Caching.Interfaces;

type
  TCaching = class(TInterfacedObject, ICaching)
  strict private
    FExpire: Integer;
    FRedisClient: IRedisClient;
  public
    constructor Create(value: IRedisClient);
    class function New(value: IRedisClient): ICaching;

    function Apagar(aChave: String): ICaching;
    function Expire(value: Integer): ICaching;
    function Update(aChave: String; aInteiro: Integer): ICaching;
    function Salvar(aChave: String; aInteiro: Integer): ICaching; overload;
    function Salvar(aChave: String; aResponseJSON: TJSONObject): ICaching; overload;
    function TryOrGetValue(aChave: String; var vInteiro: Integer): Boolean; overload;
    function TryOrGetValue(aChave: String; var vResponseJSON: TJSONObject): Boolean; overload;
  end;

implementation

{ TCashing }

function TCaching.Apagar(aChave: String): ICaching;
begin
  if Assigned(FRedisClient) then
    FRedisClient.DEL([aChave]);
end;

constructor TCaching.Create(value: IRedisClient);
begin
  inherited Create;

  FRedisClient := value;
end;

function TCaching.Expire(value: Integer): ICaching;
begin
  result := Self;

  FExpire := value;
end;

class function TCaching.New(value: IRedisClient): ICaching;
begin
  result := Self.Create(value);
end;

function TCaching.Salvar(aChave: String; aInteiro: Integer): ICaching;
var
  lExpire: Integer;

begin
  if Assigned(FRedisClient) then
  begin
    lExpire := FExpire;

    if lExpire = 0 then
      lExpire := 600;

    if not FRedisClient.EXISTS(aChave) then
      FRedisClient.&SET(aChave, intToStr(aInteiro));

    FRedisClient.EXPIRE(aChave, lExpire);
  end;
end;

function TCaching.Salvar(aChave: String; aResponseJSON: TJSONObject): ICaching;
var
  lExpire: Integer;
  lArquivoStrings: TStrings;

begin
  if Assigned(FRedisClient) then
  begin
    lExpire := FExpire;

    if lExpire = 0 then
      lExpire := 600;

    lArquivoStrings := TStringList.Create;
    try
      //lArquivoStrings.Text := AnsiReplaceStr(aResponseJSON.ToString, '\', '');
      lArquivoStrings.Text := aResponseJSON.ToString;

      if not FRedisClient.EXISTS(aChave) then
        FRedisClient.&SET(aChave, lArquivoStrings.Text);

      FRedisClient.EXPIRE(aChave, lExpire);

//      lArquivoStrings.SaveToFile('c:\temp\test.txt');

    finally
      lArquivoStrings.Free;
    end;
  end;
end;

function TCaching.TryOrGetValue(aChave: String; var vInteiro: Integer): Boolean;
var
  lValue: TRedisString;

begin
  result := false;

  if Assigned(FRedisClient) then
  begin
    lValue := FRedisClient.GET(aChave);

    if not lValue.IsNull then
    begin
      vInteiro := StrToIntDef(lValue.Value, 0);

      result := True;
    end;
  end;
end;

function TCaching.TryOrGetValue(aChave: String;
  var vResponseJSON: TJSONObject): Boolean;
var
  lValue: TRedisString;

begin
  result := false;

  if Assigned(FRedisClient) then
  begin
    lValue := FRedisClient.GET(aChave);

    if not lValue.IsNull then
    begin
      try
        vResponseJSON := TJSONObject.ParseJSONValue(lValue.Value) as TJSONObject;
      except
        //
      end;

      result := True;
    end;
  end;
end;

function TCaching.Update(aChave: String; aInteiro: Integer): ICaching;
var
  lExpire: Integer;

begin
  if Assigned(FRedisClient) then
  begin
    lExpire := FExpire;

    if lExpire = 0 then
      lExpire := 600;

    FRedisClient.&SET(aChave, intToStr(aInteiro));

    FRedisClient.EXPIRE(aChave, lExpire);
  end;
end;

end.
