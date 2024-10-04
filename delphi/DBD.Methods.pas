unit DBD.Methods;

interface

uses SysUtils, Classes, Rtti, TypInfo, Fmx.dialogs;

function executeClassMethod(const AQualifiedName, AName: string;
  const Args: array of TValue): TValue;

function executeClassMethodReturnIntArgsNone(const AQualifiedName,
  AName: PAnsiChar): Integer; stdcall;

function executeClassMethodReturnRefArgsNone(const AQualifiedName,
  AName: PAnsiChar): Pointer; stdcall;

function executeClassMethodReturnRefArgsString(const AQualifiedName, AName,
  AValue: PAnsiChar): Pointer; stdcall;

procedure executeClassMethodReturnNoneArgsString(const AQualifiedName,
  AName: PAnsiChar; const value: WideString); stdcall;

procedure executeClassMethodReturnNoneArgsNone(const AQualifiedName,
  AName: PAnsiChar); stdcall;

procedure executeClassMethodReturnNoneArgs_Out_String
  (const AQualifiedName, AName: PAnsiChar; out value: WideString); stdcall;

procedure executeClassMethodReturnNoneArgsStringStringString_Out_String
  (const AQualifiedName, AName: PAnsiChar; const v1, v2, v3: WideString;
  out value: WideString); stdcall;

function executeClassMethodReturnBoolArgsString(const AQualifiedName, AName,
  AValue: PAnsiChar): Boolean; stdcall;

procedure executeInstanceMethodReturnEnumArgsNone(Reference: Pointer;
  const AName: PAnsiChar; out value: WideString); stdcall;

function executeClassMethodReturnRefArgsRef(const AQualifiedName,
  AName: PAnsiChar; Reference: Pointer): Pointer; stdcall;

procedure executeClassMethodReturnNoneArgsRefRef(const AQualifiedName,
  AName: PAnsiChar; Reference1, Reference2: Pointer); stdcall;

function executeClassMethodReturnRefArgsIntUInt(const AQualifiedName,
  AName: PAnsiChar; I1: Integer; I2: Cardinal): Pointer; stdcall;

function executeClassMethodReturnRefArgsIntInt(const AQualifiedName,
  AName: PAnsiChar; I1, I2: Integer): Pointer; stdcall;

function executeClassMethodReturnRefArgsRefNativeInt(const AQualifiedName,
  AName: PAnsiChar; Reference: Pointer; I: NativeInt): Pointer; stdcall;

function executeClassMethodReturnRefArgsRefRefRefBool(const AQualifiedName,
  AName: PAnsiChar; Ref1, Ref2, Ref3: Pointer; B: Boolean): Pointer; stdcall;

function executeClassMethodReturnStructArgsFloatFloatFloatFloat(const AQualifiedName,
  AName: PAnsiChar; F1, F2, F3, F4: Single): Pointer; stdcall;

function executeInstanceMethod(Reference: Pointer; const AName: string;
  const Args: array of TValue): TValue;

procedure executeInstanceMethodReturnNoneArgsNone(Reference: Pointer;
  const AName: PAnsiChar); stdcall;

procedure executeInstanceMethodReturnNoneArgsRef(Reference: Pointer;
  const AName: PAnsiChar; Reference2: Pointer); stdcall;

procedure executeInstanceMethodReturnNoneArgsRefString(Reference: Pointer;
  const AName: PAnsiChar; Reference2: Pointer;
  const AValue: PAnsiChar); stdcall;

procedure executeInstanceMethodReturnNoneArgsRefBool(Reference: Pointer;
  const AName: PAnsiChar; Reference2: Pointer; B: Boolean); stdcall;

procedure executeInstanceMethodReturnNoneArgsRefInt(Reference: Pointer;
  const AName: PAnsiChar; Reference2: Pointer; I: Integer); stdcall;

procedure executeInstanceMethodReturnNoneArgsIntRef(Reference: Pointer;
  const AName: PAnsiChar; I: Integer; Reference2: Pointer); stdcall;

procedure executeInstanceMethodReturnNoneArgsStructFloat(Reference: Pointer;
  const AName: PAnsiChar; Reference2: Pointer; s: Single); stdcall;

procedure executeInstanceMethodReturnNoneArgsStructStructFloat
  (Reference: Pointer; const AName: PAnsiChar; Reference2, Reference3: Pointer;
  s: Single); stdcall;

procedure executeInstanceMethodReturnNoneArgsStructStructFloatRef
  (Reference: Pointer; const AName: PAnsiChar; Reference2, Reference3: Pointer;
  s: Single; Reference4: Pointer); stdcall;

procedure executeInstanceMethodReturnNoneArgsRefFloat(Reference: Pointer;
  const AName: PAnsiChar; Reference2: Pointer; s: Single); stdcall;

procedure executeInstanceMethodReturnNoneArgsRefStructStructFloatBoolean
  (Reference: Pointer; const AName: PAnsiChar;
  Reference2, Reference3, Reference4: Pointer; s: Single; B: Boolean); stdcall;

procedure executeInstanceMethodReturnNoneArgsFloatFloatFloatFloatFloat
  (Reference: Pointer; const AName: PAnsiChar;
  s1, s2, s3, s4, s5: Single); stdcall;

procedure executeInstanceMethodReturnNoneArgsString(Reference: Pointer;
  const AName, AValue: PAnsiChar); stdcall;

procedure executeInstanceMethodReturnNoneArgsBool(Reference: Pointer;
  const AName: PAnsiChar; AValue: Boolean); stdcall;

procedure executeInstanceMethodReturnNoneArgsBoolBool(Reference: Pointer;
  const AName: PAnsiChar; b1, b2: Boolean); stdcall;

procedure executeInstanceMethodReturnNoneArgsInt(Reference: Pointer;
  const AName: PAnsiChar; AValue: Integer); stdcall;

procedure executeInstanceMethodReturnNoneArgsUInt(Reference: Pointer;
  const AName: PAnsiChar; AValue: Cardinal); stdcall;

procedure executeInstanceMethodReturnNoneArgsLong(Reference: Pointer;
  const AName: PAnsiChar; AValue: Int64); stdcall;

procedure executeInstanceMethodReturnNoneArgsULong(Reference: Pointer;
  const AName: PAnsiChar; AValue: UInt64); stdcall;

procedure executeInstanceMethodReturnNoneArgsIntInt(Reference: Pointer;
  const AName: PAnsiChar; AValue1, AValue2: Integer); stdcall;

procedure executeInstanceMethodReturnNoneArgsFloat(Reference: Pointer;
  const AName: PAnsiChar; AValue: Single); stdcall;

procedure executeInstanceMethodReturnNoneArgsFloatFloatBool(Reference: Pointer;
  const AName: PAnsiChar; F1, F2: Single; B: Boolean); stdcall;

function executeInstanceMethodReturnIntArgsNone(Reference: Pointer;
  const AName: PAnsiChar): Integer; stdcall;

function executeInstanceMethodReturnUIntArgsNone(Reference: Pointer;
  const AName: PAnsiChar): Cardinal; stdcall;

function executeInstanceMethodReturnLongArgsNone(Reference: Pointer;
  const AName: PAnsiChar): Int64; stdcall;

function executeInstanceMethodReturnULongArgsNone(Reference: Pointer;
  const AName: PAnsiChar): UInt64; stdcall;

function executeInstanceMethodReturnFloatArgsNone(Reference: Pointer;
  const AName: PAnsiChar): Single; stdcall;

function executeInstanceMethodReturnBoolArgsNone(Reference: Pointer;
  const AName: PAnsiChar): Boolean; stdcall;

function executeInstanceMethodReturnBoolArgsBool(Reference: Pointer;
  const AName: PAnsiChar; B: Boolean): Boolean; stdcall;

function executeInstanceMethodReturnBoolArgsInt(Reference: Pointer;
  const AName: PAnsiChar; I: Integer): Boolean; stdcall;

function executeInstanceMethodReturnBoolArgsString(Reference: Pointer;
  const AName, AValue: PAnsiChar): Boolean; stdcall;

function executeInstanceMethodReturnBoolArgsFloatFloat(Reference: Pointer;
  const AName: PAnsiChar; s1, s2: Single): Boolean; stdcall;

function executeInstanceMethodReturnBoolArgsRef(Reference: Pointer;
  const AName: PAnsiChar; Reference2: Pointer): Boolean; stdcall;

function executeInstanceMethodReturnBoolArgsRefInt(Reference: Pointer;
  const AName: PAnsiChar; Reference2: Pointer; I1: integer): Boolean; stdcall;

function executeInstanceMethodReturnRefArgsNone(Reference: Pointer;
  const AName: PAnsiChar): Pointer; stdcall;

function executeInstanceMethodReturnRefArgsString(Reference: Pointer;
  const AName, AValue: PAnsiChar): Pointer; stdcall;

function executeInstanceMethodReturnRefArgsInt(Reference: Pointer;
  const AName: PAnsiChar; R: Integer): Pointer; stdcall;

function executeInstanceMethodReturnRefArgsStringBool(Reference: Pointer;
  const AName, s: PAnsiChar; B: Boolean): Pointer; stdcall;

function executeInstanceMethodReturnRefArgsStringIntBool(Reference: Pointer;
  const AName, s: PAnsiChar; i : Integer; B: Boolean): Pointer; stdcall;

function executeInstanceMethodReturnIntArgsString(Reference: Pointer;
  const AName, AValue: PAnsiChar): Integer; stdcall;

function executeInstanceMethodReturnIntArgsStringRef(Reference: Pointer;
  const AName, AValue: PAnsiChar; R: Pointer): Integer; stdcall;

procedure executeInstanceMethodReturnStringArgsNone_Out_String
  (Reference: Pointer; const AName: PAnsiChar; out value: WideString); stdcall;

procedure executeInstanceMethodReturnStringArgsInt_Out_String
  (Reference: Pointer; const AName: PAnsiChar; I: Integer;
  out value: WideString); stdcall;

procedure executeInstanceMethodReturnStringArgsIntInt_Out_String
  (Reference: Pointer; const AName: PAnsiChar; I1, I2: Integer;
  out value: WideString); stdcall;

function executeInstanceMethodReturnLongArgsUByteArrLongLong
  (Reference: Pointer; const AName: PAnsiChar; Arr : PByte; ArrLength: UInt64; L1, L2 : Int64): Int64; stdcall;

exports executeInstanceMethodReturnNoneArgsNone,
  executeInstanceMethodReturnRefArgsNone, executeClassMethodReturnRefArgsString,
  executeInstanceMethodReturnIntArgsNone,
  executeInstanceMethodReturnUIntArgsNone,
  executeInstanceMethodReturnLongArgsNone,
  executeInstanceMethodReturnULongArgsNone,
  executeInstanceMethodReturnFloatArgsNone,
  executeInstanceMethodReturnBoolArgsNone,
  executeInstanceMethodReturnBoolArgsBool,
  executeInstanceMethodReturnBoolArgsInt,
  executeInstanceMethodReturnBoolArgsString,
  executeInstanceMethodReturnBoolArgsFloatFloat,
  executeInstanceMethodReturnBoolArgsRef,
  executeInstanceMethodReturnBoolArgsRefInt,
  executeInstanceMethodReturnIntArgsString,
  executeInstanceMethodReturnIntArgsStringRef,
  executeClassMethodReturnRefArgsNone,
  executeClassMethodReturnRefArgsIntInt,
  executeClassMethodReturnNoneArgsRefRef,
  executeClassMethodReturnNoneArgs_Out_String,
  executeClassMethodReturnNoneArgsStringStringString_Out_String,
  executeClassMethodReturnStructArgsFloatFloatFloatFloat,
  executeInstanceMethodReturnRefArgsString, executeClassMethodReturnRefArgsRef,
  executeInstanceMethodReturnNoneArgsStructFloat,
  executeInstanceMethodReturnNoneArgsRefFloat,
  executeInstanceMethodReturnNoneArgsStructStructFloat,
  executeInstanceMethodReturnNoneArgsStructStructFloatRef,
  executeInstanceMethodReturnNoneArgsFloatFloatFloatFloatFloat,
  executeInstanceMethodReturnNoneArgsString,
  executeInstanceMethodReturnNoneArgsBool,
  executeInstanceMethodReturnNoneArgsBoolBool,
  executeInstanceMethodReturnNoneArgsInt,
  executeInstanceMethodReturnNoneArgsUInt,
  executeInstanceMethodReturnNoneArgsLong,
  executeInstanceMethodReturnNoneArgsULong,
  executeInstanceMethodReturnNoneArgsIntInt,
  executeInstanceMethodReturnNoneArgsIntRef,
  executeInstanceMethodReturnNoneArgsFloat,
  executeInstanceMethodReturnNoneArgsRefStructStructFloatBoolean,
  executeClassMethodReturnRefArgsRefNativeInt,
  executeClassMethodReturnRefArgsRefRefRefBool,
  executeClassMethodReturnRefArgsIntUInt,
  executeClassMethodReturnIntArgsNone,
  executeInstanceMethodReturnNoneArgsRef,
  executeInstanceMethodReturnNoneArgsRefString,
  executeInstanceMethodReturnNoneArgsRefBool,
  executeInstanceMethodReturnNoneArgsRefInt,
  executeClassMethodReturnNoneArgsString, executeClassMethodReturnNoneArgsNone,
  executeClassMethodReturnBoolArgsString,
  executeInstanceMethodReturnEnumArgsNone,
  executeInstanceMethodReturnRefArgsInt,
  executeInstanceMethodReturnRefArgsStringBool,
  executeInstanceMethodReturnRefArgsStringIntBool,
  executeInstanceMethodReturnStringArgsNone_Out_String,
  executeInstanceMethodReturnStringArgsInt_Out_String,
  executeInstanceMethodReturnStringArgsIntInt_Out_String,
  executeInstanceMethodReturnLongArgsUByteArrLongLong;

implementation

function executeClassMethod(const AQualifiedName, AName: string;
  const Args: array of TValue): TValue;
var
  context: TRttiContext;
  method: TRttiMethod;
  instType: TRttiInstanceType;
begin
  context := TRttiContext.Create;
  try
    try
      instType := (context.FindType(AQualifiedName) as TRttiInstanceType);
      if instType = nil then
      begin
        writeln('Class ' + AQualifiedName + ' not found');
      end
      else
      begin
        method := instType.GetMethod(AName);
        if method = nil then
          writeln('Class ' + instType.Name + ' does not have method ' + AName)
        else
          result := method.Invoke(instType.MetaclassType, Args);
      end;
    except
      on E: Exception do
        writeln(E.ClassName + ' error raised, with message : ' + E.Message);
    end;

  finally
    context.Free;
  end;
end;

function executeClassMethodReturnIntArgsNone(const AQualifiedName,
  AName: PAnsiChar): Integer; stdcall;
var
  value: TValue;
begin
  value := executeClassMethod(string(AQualifiedName), string(AName), []);
  result := value.AsInteger;
end;

function executeClassMethodReturnBoolArgsString(const AQualifiedName, AName,
  AValue: PAnsiChar): Boolean;
var
  value: TValue;
begin
  value := executeClassMethod(string(AQualifiedName), string(AName),
    [string(AValue)]);
  result := value.AsBoolean;
end;

function executeClassMethodReturnRefArgsString(const AQualifiedName, AName,
  AValue: PAnsiChar): Pointer; stdcall;
var
  value: TValue;
begin
  value := executeClassMethod(string(AQualifiedName), string(AName),
    [string(AValue)]);
  result := value.AsObject;
end;

procedure executeClassMethodReturnNoneArgsString(const AQualifiedName,
  AName: PAnsiChar; const value: WideString); stdcall;
begin
  executeClassMethod(string(AQualifiedName), string(AName), [string(value)]);
end;

procedure executeClassMethodReturnNoneArgsNone(const AQualifiedName,
  AName: PAnsiChar); stdcall;
begin
  executeClassMethod(string(AQualifiedName), string(AName), []);
end;

function executeClassMethodReturnRefArgsNone(const AQualifiedName,
  AName: PAnsiChar): Pointer; stdcall;
var
  value: TValue;
begin
  value := executeClassMethod(string(AQualifiedName), string(AName), []);
  result := value.AsObject;
end;

procedure executeClassMethodReturnNoneArgsRefRef(const AQualifiedName,
  AName: PAnsiChar; Reference1, Reference2: Pointer);
var
  obj1, obj2: TObject;
begin
  if Reference1 = nil then
    obj1 := nil
  else
    obj1 := TObject(Reference1);

  if Reference2 = nil then
    obj2 := nil
  else
    obj2 := TObject(Reference2);

  executeClassMethod(string(AQualifiedName), string(AName), [obj1, obj2]);
end;

function executeClassMethodReturnRefArgsRef(const AQualifiedName,
  AName: PAnsiChar; Reference: Pointer): Pointer; stdcall;
var
  value: TValue;
  obj: TObject;
begin
  if Reference = nil then
    obj := nil
  else
    obj := TObject(Reference);

  value := executeClassMethod(string(AQualifiedName), string(AName), [obj]);
  result := value.AsObject;
end;

function executeClassMethodReturnRefArgsRefNativeInt(const AQualifiedName,
  AName: PAnsiChar; Reference: Pointer; I: NativeInt): Pointer; stdcall;
var
  value: TValue;
  obj: TObject;
begin
  if Reference = nil then
    obj := nil
  else
    obj := TObject(Reference);

  value := executeClassMethod(string(AQualifiedName), string(AName), [obj, I]);
  result := value.AsObject;
end;

function executeClassMethodReturnRefArgsRefRefRefBool(const AQualifiedName,
  AName: PAnsiChar; Ref1, Ref2, Ref3: Pointer; B: Boolean): Pointer; stdcall;
var
  value: TValue;
  obj1, obj2, obj3: TObject;
begin
  if Ref1 = nil then
    obj1 := nil
  else
    obj1 := TObject(Ref1);

  if Ref2 = nil then
    obj2 := nil
  else
    obj2 := TObject(Ref2);

  if Ref3 = nil then
    obj3 := nil
  else
    obj3 := TObject(Ref3);

  value := executeClassMethod(string(AQualifiedName), string(AName),
    [obj1, obj2, obj3, B]);
  result := value.AsObject;
end;

function executeClassMethodReturnRefArgsIntInt(const AQualifiedName,
  AName: PAnsiChar; I1, I2: Integer): Pointer; stdcall;
var
  value: TValue;
begin
  value := executeClassMethod(string(AQualifiedName), string(AName), [I1, I2]);
  result := value.AsObject;
end;

function executeClassMethodReturnRefArgsIntUInt(const AQualifiedName,
  AName: PAnsiChar; I1: Integer; I2: Cardinal): Pointer; stdcall;
var
  value: TValue;
begin
  value := executeClassMethod(string(AQualifiedName), string(AName), [I1, I2]);
  result := value.AsObject;
end;

function executeInstanceMethod(Reference: Pointer; const AName: string;
  const Args: array of TValue): TValue;
var
  context: TRttiContext;
  instType: TRttiInstanceType;
  obj: TObject;
  meth: TRttiMethod;
  parameters: TArray<TRttiParameter>;
  Found: Boolean;
  index: Integer;
begin
  context := TRttiContext.Create;
  try
    try
      meth := nil;
      found := false;
      obj := TObject(Reference);
      instType := (context.GetType(obj.ClassType) as TRttiInstanceType);

      for meth in instType.GetMethods do
        if SameText(meth.Name, AName) then
        begin
          parameters := meth.GetParameters;

          if Length(Args) = Length(parameters) then
          begin
            Found := True;
            for Index := 0 to Length(parameters) - 1 do

              if parameters[Index].ParamType.Handle <> Args[Index].TypeInfo then
              begin

                IF Args[Index].IsObject AND Args[Index].AsObject.InheritsFrom(
                  parameters[Index].ParamType.AsInstance.MetaclassType
                ) then begin

                end else begin
                  Found := False;
                  Break;
                end;




              end;
          end;

          if Found then
            Break;
        end;

      if (meth <> nil) and Found then  begin
        result := meth.Invoke(obj, Args) ;
      end
      else
        raise Exception.CreateFmt('method %s not found', [AName]);


//        This won't work when you pass in a descendant class. For example,
//        if I have a method Add(MyObject: TObject) and pass in a TComponent,
//         the method with the right parameters won't be found.
//         You need to also check for inheritance in the case of objects
//          with something like
//          Args[LIndex].AsObject.InheritsFrom(LParams[LIndex].ParamType.AsInstance.MetaclassType)


      // meth := instType.GetMethod(AName);
      // if meth = nil then
      // writeln('Class ' + instType.Name + ' does not have method ' + AName)
      // else
      // result := instType.GetMethod(AName).Invoke(obj, Args);

    except
      on E: Exception do
        writeln(E.ClassName + ' error raised, with message : ' + E.Message);
    end;
  finally
    context.Free;
  end;
end;

procedure executeInstanceMethodReturnNoneArgsNone(Reference: Pointer;
  const AName: PAnsiChar); stdcall;
begin
  executeInstanceMethod(Reference, string(AName), []);
end;

function executeInstanceMethodReturnIntArgsNone(Reference: Pointer;
  const AName: PAnsiChar): Integer; stdcall;
var
  value: TValue;
begin
  value := executeInstanceMethod(Reference, string(AName), []);
  result := Integer(value.AsInteger);
end;

function executeInstanceMethodReturnUIntArgsNone(Reference: Pointer;
  const AName: PAnsiChar): Cardinal; stdcall;
var
  value: TValue;
begin
  value := executeInstanceMethod(Reference, string(AName), []);
  result := value.AsType<Cardinal>;
end;

function executeInstanceMethodReturnLongArgsNone(Reference: Pointer;
  const AName: PAnsiChar): Int64; stdcall;
var
  value: TValue;
begin
  value := executeInstanceMethod(Reference, string(AName), []);
  result := value.AsInt64;
end;

function executeInstanceMethodReturnULongArgsNone(Reference: Pointer;
  const AName: PAnsiChar): UInt64; stdcall;
var
  value: TValue;
begin
  value := executeInstanceMethod(Reference, string(AName), []);
  result := value.AsType<UInt64>;
end;

function executeInstanceMethodReturnFloatArgsNone(Reference: Pointer;
  const AName: PAnsiChar): Single; stdcall;
var
  value: TValue;
begin
  value := executeInstanceMethod(Reference, string(AName), []);
  result := value.AsType<Single>;
end;

function executeInstanceMethodReturnBoolArgsNone(Reference: Pointer;
  const AName: PAnsiChar): Boolean; stdcall;
var
  value: TValue;
begin
  value := executeInstanceMethod(Reference, string(AName), []);
  result := Boolean(value.AsBoolean);
end;

function executeInstanceMethodReturnBoolArgsBool(Reference: Pointer;
  const AName: PAnsiChar; B: Boolean): Boolean; stdcall;
var
  value: TValue;
begin
  value := executeInstanceMethod(Reference, string(AName), [B]);
  result := Boolean(value.AsBoolean);
end;

function executeInstanceMethodReturnBoolArgsInt(Reference: Pointer;
  const AName: PAnsiChar; I: Integer): Boolean; stdcall;
var
  value: TValue;
begin
  value := executeInstanceMethod(Reference, string(AName), [I]);
  result := Boolean(value.AsBoolean);
end;

function executeInstanceMethodReturnBoolArgsString(Reference: Pointer;
  const AName, AValue: PAnsiChar): Boolean; stdcall;
var
  value: TValue;
begin
  value := executeInstanceMethod(Reference, string(AName), [string(AValue)]);
  result := Boolean(value.AsBoolean);
end;

function executeInstanceMethodReturnBoolArgsFloatFloat(Reference: Pointer;
  const AName: PAnsiChar; s1, s2: Single): Boolean; stdcall;
var
  value: TValue;
begin
  value := executeInstanceMethod(Reference, string(AName), [s1, s2]);
  result := Boolean(value.AsBoolean);
end;

function executeInstanceMethodReturnBoolArgsRef(Reference: Pointer;
  const AName: PAnsiChar; Reference2: Pointer): Boolean; stdcall;
var
  value: TValue;
  obj: TObject;
begin
  if Reference2 = nil then
    obj := nil
  else
    obj := TObject(Reference2);
  value := executeInstanceMethod(Reference, string(AName), [obj]);
  result := Boolean(value.AsBoolean);
end;

function executeInstanceMethodReturnBoolArgsRefInt(Reference: Pointer;
  const AName: PAnsiChar; Reference2: Pointer; I1: Integer): Boolean; stdcall;
var
  value: TValue;
  obj: TObject;
begin
  if Reference2 = nil then
    obj := nil
  else
    obj := TObject(Reference2);
  value := executeInstanceMethod(Reference, string(AName), [obj, I1]);
  result := Boolean(value.AsBoolean);
end;

function executeInstanceMethodReturnRefArgsNone(Reference: Pointer;
  const AName: PAnsiChar): Pointer; stdcall;
var
  value: TValue;
begin
  value := executeInstanceMethod(Reference, string(AName), []);
  result := value.AsObject;
end;

procedure executeInstanceMethodReturnNoneArgsRef(Reference: Pointer;
  const AName: PAnsiChar; Reference2: Pointer); stdcall;
var
  obj: TObject;
begin
  if Reference2 = nil then
    obj := nil
  else
    obj := TObject(Reference2);
  executeInstanceMethod(Reference, string(AName), [obj]);
end;

procedure executeInstanceMethodReturnNoneArgsRefString(Reference: Pointer;
  const AName: PAnsiChar; Reference2: Pointer;
  const AValue: PAnsiChar); stdcall;
var
  obj: TObject;
begin
  if Reference2 = nil then
    obj := nil
  else
    obj := TObject(Reference2);
  executeInstanceMethod(Reference, string(AName), [obj, string(AValue)]);
end;

procedure executeInstanceMethodReturnNoneArgsRefBool(Reference: Pointer;
  const AName: PAnsiChar; Reference2: Pointer; B: Boolean); stdcall;
var
  obj: TObject;
begin
  if Reference2 = nil then
    obj := nil
  else
    obj := TObject(Reference2);
  executeInstanceMethod(Reference, string(AName), [obj, B]);
end;

procedure executeInstanceMethodReturnNoneArgsRefInt(Reference: Pointer;
  const AName: PAnsiChar; Reference2: Pointer; I: Integer); stdcall;
var
  obj: TObject;
begin
  if Reference2 = nil then
    obj := nil
  else
    obj := TObject(Reference2);
  executeInstanceMethod(Reference, string(AName), [obj, I]);
end;

procedure executeInstanceMethodReturnNoneArgsIntRef(Reference: Pointer;
  const AName: PAnsiChar; I: Integer; Reference2: Pointer); stdcall;
var
  obj: TObject;
begin
  if Reference2 = nil then
    obj := nil
  else
    obj := TObject(Reference2);
  executeInstanceMethod(Reference, string(AName), [obj, I]);
end;

procedure executeInstanceMethodReturnNoneArgsRefFloat(Reference: Pointer;
  const AName: PAnsiChar; Reference2: Pointer; s: Single); stdcall;
var
  obj: TObject;
begin
  if Reference2 = nil then
    obj := nil
  else
    obj := TObject(Reference2);
  executeInstanceMethod(Reference, string(AName), [obj, s]);
end;

procedure executeInstanceMethodReturnNoneArgsStructFloat(Reference: Pointer;
  const AName: PAnsiChar; Reference2: Pointer; s: Single); stdcall;
var
  context: TRttiContext;
  instType: TRttiInstanceType;
  params: TArray<TRttiParameter>;
  obj: TObject;
  Arg1: TValue;
begin
  context := TRttiContext.Create;
  try
    try
      obj := TObject(Reference);
      instType := (context.GetType(obj.ClassType) as TRttiInstanceType);
      params := instType.GetMethod(string(AName)).GetParameters;
      TValue.Make(Pointer(Reference2), params[0].ParamType.Handle, Arg1);
      executeInstanceMethod(Reference, string(AName), [Arg1, s]);
    except
      on E: Exception do
        writeln(E.ClassName + ' error raised, with message : ' + E.Message);
    end;
  finally
    context.Free;
  end;
end;

procedure executeInstanceMethodReturnNoneArgsStructStructFloat
  (Reference: Pointer; const AName: PAnsiChar; Reference2, Reference3: Pointer;
  s: Single); stdcall;
var
  context: TRttiContext;
  instType: TRttiInstanceType;
  params: TArray<TRttiParameter>;
  obj: TObject;
  Arg1: TValue;
  Arg2: TValue;
begin
  context := TRttiContext.Create;
  try
    try
      obj := TObject(Reference);
      instType := (context.GetType(obj.ClassType) as TRttiInstanceType);
      params := instType.GetMethod(string(AName)).GetParameters;

      TValue.Make(Pointer(Reference2), params[0].ParamType.Handle, Arg1);
      TValue.Make(Pointer(Reference3), params[1].ParamType.Handle, Arg2);

      executeInstanceMethod(Reference, string(AName), [Arg1, Arg2, s]);
    except
      on E: Exception do
        writeln(E.ClassName + ' error raised, with message : ' + E.Message);
    end;
  finally
    context.Free;
  end;
end;

procedure executeInstanceMethodReturnNoneArgsStructStructFloatRef
  (Reference: Pointer; const AName: PAnsiChar; Reference2, Reference3: Pointer;
  s: Single; Reference4: Pointer); stdcall;
var
  context: TRttiContext;
  instType: TRttiInstanceType;
  params: TArray<TRttiParameter>;
  obj: TObject;
  Arg1: TValue;
  Arg2: TValue;
begin
  context := TRttiContext.Create;
  try
    try
      obj := TObject(Reference);
      instType := (context.GetType(obj.ClassType) as TRttiInstanceType);
      params := instType.GetMethod(string(AName)).GetParameters;

      TValue.Make(Pointer(Reference2), params[0].ParamType.Handle, Arg1);
      TValue.Make(Pointer(Reference3), params[1].ParamType.Handle, Arg2);

      executeInstanceMethod(Reference, string(AName),
        [Arg1, Arg2, s, TObject(Reference4)]);
    except
      on E: Exception do
        writeln(E.ClassName + ' error raised, with message : ' + E.Message);
    end;
  finally
    context.Free;
  end;
end;

procedure executeInstanceMethodReturnNoneArgsRefStructStructFloatBoolean
  (Reference: Pointer; const AName: PAnsiChar;
  Reference2, Reference3, Reference4: Pointer; s: Single; B: Boolean); stdcall;
var
  context: TRttiContext;
  instType: TRttiInstanceType;
  params: TArray<TRttiParameter>;
  obj: TObject;
  Arg1: TValue;
  Arg2: TValue;
Begin
  context := TRttiContext.Create;
  try
    try
      obj := TObject(Reference);
      instType := (context.GetType(obj.ClassType) as TRttiInstanceType);
      params := instType.GetMethod(string(AName)).GetParameters;
      TValue.Make(Pointer(Reference3), params[1].ParamType.Handle, Arg1);
      TValue.Make(Pointer(Reference4), params[2].ParamType.Handle, Arg2);

      executeInstanceMethod(Reference, string(AName),
        [TObject(Reference2), Arg1, Arg2, s, B]);
    except
      on E: Exception do
        writeln(E.ClassName + ' error raised, with message : ' + E.Message);
    end;
  finally
    context.Free;
  end;
End;

procedure executeInstanceMethodReturnNoneArgsString(Reference: Pointer;
  const AName, AValue: PAnsiChar); stdcall;
begin
  executeInstanceMethod(Reference, string(AName), [string(AValue)]);
end;

procedure executeInstanceMethodReturnNoneArgsBool(Reference: Pointer;
  const AName: PAnsiChar; AValue: Boolean); stdcall;
begin
  executeInstanceMethod(Reference, string(AName), [AValue]);
end;

procedure executeInstanceMethodReturnNoneArgsBoolBool(Reference: Pointer;
  const AName: PAnsiChar; b1, b2: Boolean); stdcall;
begin
  executeInstanceMethod(Reference, string(AName), [b1, b2]);
end;

procedure executeInstanceMethodReturnNoneArgsInt(Reference: Pointer;
  const AName: PAnsiChar; AValue: Integer); stdcall;
begin
  executeInstanceMethod(Reference, string(AName), [AValue]);
end;

procedure executeInstanceMethodReturnNoneArgsUInt(Reference: Pointer;
  const AName: PAnsiChar; AValue: Cardinal); stdcall;
begin
  executeInstanceMethod(Reference, string(AName), [AValue]);
end;

procedure executeInstanceMethodReturnNoneArgsLong(Reference: Pointer;
  const AName: PAnsiChar; AValue: Int64); stdcall;
begin
  executeInstanceMethod(Reference, string(AName), [AValue]);
end;

procedure executeInstanceMethodReturnNoneArgsULong(Reference: Pointer;
  const AName: PAnsiChar; AValue: UInt64); stdcall;
begin
  executeInstanceMethod(Reference, string(AName), [AValue]);
end;

procedure executeInstanceMethodReturnNoneArgsIntInt(Reference: Pointer;
  const AName: PAnsiChar; AValue1, AValue2: Integer); stdcall;
begin
  executeInstanceMethod(Reference, string(AName), [AValue1, AValue2]);
end;

procedure executeInstanceMethodReturnNoneArgsFloat(Reference: Pointer;
  const AName: PAnsiChar; AValue: Single); stdcall;
begin
  executeInstanceMethod(Reference, string(AName), [AValue]);
end;

procedure executeInstanceMethodReturnNoneArgsFloatFloatBool(Reference: Pointer;
  const AName: PAnsiChar; F1, F2: Single; B: Boolean); stdcall;
begin
  executeInstanceMethod(Reference, string(AName), [F1, F2, B]);
end;

procedure executeInstanceMethodReturnNoneArgsFloatFloatFloatFloatFloat
  (Reference: Pointer; const AName: PAnsiChar;
  s1, s2, s3, s4, s5: Single); stdcall;
begin
  executeInstanceMethod(Reference, string(AName), [s1, s2, s3, s4, s5]);
end;

function executeInstanceMethodReturnRefArgsInt(Reference: Pointer;
  const AName: PAnsiChar; R: Integer): Pointer; stdcall;
var
  value: TValue;
begin
  value := executeInstanceMethod(Reference, string(AName), [R]);
  result := value.AsObject;
end;

function executeInstanceMethodReturnRefArgsStringBool(Reference: Pointer;
  const AName, s: PAnsiChar; B: Boolean): Pointer; stdcall;
var
  value: TValue;
begin
  value := executeInstanceMethod(Reference, string(AName), [string(s), B]);
  result := value.AsObject;
end;

function executeInstanceMethodReturnRefArgsStringIntBool(Reference: Pointer;
  const AName, s: PAnsiChar; I: Integer; B: Boolean): Pointer; stdcall;
var
  value: TValue;
begin
  value := executeInstanceMethod(Reference, string(AName), [string(s), I, B]);
  result := value.AsObject;
end;

function executeInstanceMethodReturnRefArgsString(Reference: Pointer;
  const AName, AValue: PAnsiChar): Pointer; stdcall;
var
  value: TValue;
begin
  value := executeInstanceMethod(Reference, string(AName), [string(AValue)]);
  result := value.AsObject;
end;

function executeInstanceMethodReturnIntArgsString(Reference: Pointer;
  const AName, AValue: PAnsiChar): Integer; stdcall;
var
  value: TValue;
begin
  value := executeInstanceMethod(Reference, string(AName), [string(AValue)]);
  result := value.AsInteger;
end;

function executeInstanceMethodReturnIntArgsStringRef(Reference: Pointer;
  const AName, AValue: PAnsiChar; R: Pointer): Integer; stdcall;
var
  value: TValue;
begin
  value := executeInstanceMethod(Reference, string(AName),
    [string(AValue), TObject(R)]);
  result := value.AsInteger;
end;

procedure executeInstanceMethodReturnStringArgsNone_Out_String
  (Reference: Pointer; const AName: PAnsiChar; out value: WideString); stdcall;
var
  methodResultValue: TValue;
begin
  methodResultValue := executeInstanceMethod(Reference, string(AName), []);
  value := methodResultValue.AsString;
end;

procedure executeInstanceMethodReturnStringArgsInt_Out_String
  (Reference: Pointer; const AName: PAnsiChar; I: Integer;
  out value: WideString); stdcall;
var
  methodResultValue: TValue;
begin
  methodResultValue := executeInstanceMethod(Reference, string(AName), [I]);
  value := methodResultValue.AsString;
end;

procedure executeInstanceMethodReturnStringArgsIntInt_Out_String
  (Reference: Pointer; const AName: PAnsiChar; I1, I2: Integer;
  out value: WideString); stdcall;
var
  methodResultValue: TValue;
begin
  methodResultValue := executeInstanceMethod(Reference, string(AName),
    [I1, I2]);
  value := methodResultValue.AsString;
end;

procedure executeInstanceMethodReturnEnumArgsNone(Reference: Pointer;
  const AName: PAnsiChar; out value: WideString); stdcall;
var
  s: String;
  methodResultValue: TValue;
begin
  methodResultValue := executeInstanceMethod(Reference, string(AName), []);
  s := methodResultValue.AsString;
  value := s;
end;

{POINTERMATH ON}
function executeInstanceMethodReturnLongArgsUByteArrLongLong
  (Reference: Pointer; const AName: PAnsiChar; Arr : PByte; ArrLength: UInt64; L1, L2 : Int64): Int64;
var
  value: TValue;
  delphiArr: TBytes;
begin
  SetLength(delphiArr, ArrLength);
  Move(Arr^, Pointer(delphiArr)^, ArrLength*SizeOf(Arr^));
  value := executeInstanceMethod(Reference, string(AName), [TValue.From(delphiArr), L1, L2]);
  result := value.AsInt64;
end;

procedure executeClassMethodReturnNoneArgsStringStringString_Out_String
  (const AQualifiedName, AName: PAnsiChar; const v1, v2, v3: WideString;
  out value: WideString); stdcall;
var
  methodResultValue: TValue;
begin
  methodResultValue := executeClassMethod(string(AQualifiedName), string(AName),
    [string(v1), string(v2), string(v3)]);
  value := methodResultValue.AsString;
end;

procedure executeClassMethodReturnNoneArgs_Out_String
  (const AQualifiedName, AName: PAnsiChar; out value: WideString);
var
  methodResultValue: TValue;
begin
  methodResultValue := executeClassMethod(string(AQualifiedName), string(AName),
    []);
  value := methodResultValue.AsString;
end;

function executeClassMethodReturnStructArgsFloatFloatFloatFloat(const AQualifiedName,
  AName: PAnsiChar; F1, F2, F3, F4: Single): Pointer;
var
  value: TValue;
begin
  value := executeClassMethod(string(AQualifiedName), string(AName), [F1, F2, F3, F4]);
  result := value.GetReferenceToRawData;
end;




end.
