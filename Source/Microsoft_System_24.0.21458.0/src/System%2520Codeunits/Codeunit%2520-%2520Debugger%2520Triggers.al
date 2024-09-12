// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------
namespace System.Tooling;

codeunit 2000000009 "Debugger Triggers"
{
    SingleInstance = true;

    trigger OnRun()
    begin
    end;

    [BusinessEvent(false)]
    [Obsolete('Support for the classic debugger engine has been removed.')]
    procedure OnDebuggerBreak(ErrorMessage: Text)
    begin
    end;
}

