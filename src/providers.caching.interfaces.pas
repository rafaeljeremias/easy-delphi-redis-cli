unit Providers.Caching.Interfaces;

interface

Uses
  JSON;

type
  ICaching = Interface
    ['{C2AD5FD9-2D0E-41BB-A96D-F22B3A2F15FD}']
    function Apagar(aChave: String): ICaching;
    function Expire(value: Integer): ICaching;
    function Update(aChave: String; aInteiro: Integer): ICaching;
    function Salvar(aChave: String; aInteiro: Integer): ICaching; overload;
    function Salvar(aChave: String; aResponseJSON: TJSONObject): ICaching; overload;
    function TryOrGetValue(aChave: String; var vInteiro: Integer): Boolean; overload;
    function TryOrGetValue(aChave: String; var vResponseJSON: TJSONObject): Boolean; overload;
  End;

implementation

end.
