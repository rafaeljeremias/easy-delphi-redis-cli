unit providers.redis.factory;

interface

uses
  Redis.Client,
  Redis.Values,
  Redis.Commons,
  ERP.Utils.Vars,
  System.IniFiles,
  System.StrUtils,
  System.SysUtils,
  ERP.Utils.Consts,
  Redis.NetLib.Indy;

type
  IProvidersRedisFactory = Interface
    ['{E871CBC0-27B7-40CE-8880-345E9ED1270C}']
    function GetInstance: IRedisClient;
  End;

  TProvidersRedisFactory = class(TInterfacedObject, IProvidersRedisFactory)
  strict private
    FServerRedis: String;
  public
    constructor Create;
    class function New: IProvidersRedisFactory;

    function GetInstance: IRedisClient;
  End;

implementation

{ TProvidersRedisFactory }

constructor TProvidersRedisFactory.Create;
var
  lIni: TIniFile;

begin
  lIni := TIniFile.Create(IncludeTrailingPathDelimiter(GetCurrentDir) + ARQUIVO_CONFIG);
  try
    FServerRedis := lIni.ReadString('redis', 'server', '');
  finally
    lIni.Free;
  end;
end;

function TProvidersRedisFactory.GetInstance: IRedisClient;
begin
  if (FServerRedis <> '')and not Assigned(GServerRedis) then
  begin
    GServerRedis := TRedisClient.Create(FServerRedis);
    GServerRedis.Connect;
  end;

  result := GServerRedis;
end;

class function TProvidersRedisFactory.New: IProvidersRedisFactory;
begin
  result := Self.Create;
end;

end.
