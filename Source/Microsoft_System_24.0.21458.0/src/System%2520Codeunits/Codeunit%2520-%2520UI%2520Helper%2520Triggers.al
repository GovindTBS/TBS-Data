// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------
namespace System.Environment;

codeunit 2000000004 "UI Helper Triggers"
{
    SingleInstance = true;

    trigger OnRun()
    begin
    end;

    [BusinessEvent(false)]
    procedure AutoFormatTranslate(AutoFormatType: Integer; AutoFormatExpr: Text[80]; var Translation: Text[80])
    begin
    end;

    [BusinessEvent(false)]
    procedure GetDefaultRoundingPrecision(var AmountRoundingPrecision: Decimal)
    begin
    end;

    [BusinessEvent(false)]
    procedure CaptionClassTranslate(Language: Integer; CaptionExpr: Text[1024]; var Translation: Text[1024])
    begin
    end;

    [BusinessEvent(false)]
    procedure GetSystemIndicator(var Text: Text[250]; var Style: Option Standard,Accent1,Accent2,Accent3,Accent4,Accent5,Accent6,Accent7,Accent8,Accent9)
    begin
    end;

    [BusinessEvent(false)]
    procedure GetCueStyle(TableId: Integer; FieldNo: Integer; CueValue: Decimal; var StyleText: Text)
    begin
    end;

    [BusinessEvent(false)]
    procedure GetApplicationLanguage(var Language: Integer)
    begin
    end;
}

