// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------
namespace System.Environment;

codeunit 2000000001 "Version Triggers"
{
    SingleInstance = true;

    trigger OnRun()
    begin
    end;

    [BusinessEvent(false)]
    procedure GetApplicationVersion(var Version: Text[248])
    begin
    end;

    [BusinessEvent(false)]
    procedure GetReleaseVersion(var Version: Text[50])
    begin
    end;

    [BusinessEvent(false)]
    procedure GetApplicationBuild(var Build: Text[80])
    begin
    end;
}

