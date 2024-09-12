// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------
namespace System.Upgrade;

codeunit 2000000008 "Upgrade Triggers"
{
    SingleInstance = true;

    trigger OnRun()
    begin
    end;

#pragma warning disable AL0299
    [BusinessEvent(false)]
    procedure OnCheckPreconditionsPerDatabase()
    begin
    end;

    [BusinessEvent(false)]
    procedure OnCheckPreconditionsPerCompany()
    begin
    end;

    [BusinessEvent(false)]
    procedure OnUpgradePerDatabase()
    begin
    end;

    [BusinessEvent(false)]
    procedure OnUpgradePerCompany()
    begin
    end;

    [BusinessEvent(false)]
    procedure OnValidateUpgradePerDatabase()
    begin
    end;

    [BusinessEvent(false)]
    procedure OnValidateUpgradePerCompany()
    begin
    end;

    [BusinessEvent(false)]
    procedure OnAfterUpgradeCommitPerDatabase()
    begin
    end;

    [BusinessEvent(false)]
    procedure OnAfterUpgradeCommitPerCompany()
    begin
    end;
#pragma warning restore AL0299
}

