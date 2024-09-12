// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------
namespace System.Environment;

codeunit 2000000014 "User Triggers"
{
    SingleInstance = true;

    trigger OnRun()
    begin
    end;

    [BusinessEvent(false)]
    procedure OnAfterUserInitialization()
    begin
    end;
}

