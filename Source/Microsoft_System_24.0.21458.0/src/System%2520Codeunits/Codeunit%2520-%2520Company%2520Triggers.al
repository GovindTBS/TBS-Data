// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------
namespace System.Environment;

codeunit 2000000003 "Company Triggers"
{
    SingleInstance = true;

    trigger OnRun()
    begin
    end;

    [Scope('OnPrem')]
    [BusinessEvent(false)]
    procedure OnCompanyOpen()
    begin
    end;

    [BusinessEvent(false, true)]
    procedure OnCompanyOpenCompleted()
    begin
    end;

    [BusinessEvent(false)]
    procedure OnCompanyClose()
    begin
    end;

    [BusinessEvent(false)]
    procedure OpenCompanySettings()
    begin
    end;
}

