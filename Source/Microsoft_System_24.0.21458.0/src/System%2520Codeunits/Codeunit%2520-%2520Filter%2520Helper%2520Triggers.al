// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------
namespace System.Text;

codeunit 2000000007 "Filter Helper Triggers"
{
    SingleInstance = true;

    trigger OnRun()
    begin
    end;

    [BusinessEvent(false)]
    procedure MakeDateTimeFilter(var DateTimeFilterText: Text)
    begin
    end;

    [BusinessEvent(false)]
    procedure MakeIntFilter(var IntFilterText: Text)
    begin
    end;

    [BusinessEvent(false)]
    procedure MakeDateFilter(var DateFilterText: Text)
    begin
    end;

    [BusinessEvent(false)]
    procedure MakeTextFilter(var TextFilterText: Text)
    begin
    end;

    [BusinessEvent(false)]
    procedure MakeCodeFilter(var TextFilterText: Text)
    begin
    end;

    [BusinessEvent(false)]
    procedure MakeTimeFilter(var TimeFilterText: Text)
    begin
    end;
}

