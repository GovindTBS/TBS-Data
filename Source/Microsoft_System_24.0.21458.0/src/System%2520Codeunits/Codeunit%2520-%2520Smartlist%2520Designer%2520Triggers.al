// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------
namespace System.Tooling;

codeunit 2000000011 "SmartList Designer Triggers"
{
    SingleInstance = true;

    trigger OnRun()
    begin
    end;

    [BusinessEvent(false)]
    procedure GetEnabled(var Enabled: Boolean)
    begin
    end;

    [BusinessEvent(false)]
    [Obsolete('Use OnCreateNewForTableAndView instead')]
    procedure OnCreateForTable(TableId: Integer)
    begin
    end;

    [BusinessEvent(false)]
    procedure OnCreateNewForTableAndView(TableId: Integer; ViewId: Text)
    begin
    end;

    [BusinessEvent(false)]
    procedure OnEditQuery(QueryId: Text)
    begin
    end;

    [BusinessEvent(false)]
    procedure OnInvalidQueryNavigation(Id: BigInteger)
    begin
    end;
}