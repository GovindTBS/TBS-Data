// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------
namespace System.Device;

table 2000000229 "Report Printer"
{
    DataPerCompany = False;
    Scope = OnPrem;
    fields
    {
        field(1; ID; Text[250])
        {
            Caption = 'ID';
        }
        field(2; Name; Text[250])
        {
            Caption = 'Name';
        }
        field(3; Driver; Text[50])
        {
            Caption = 'Driver';
        }
        field(4; Device; Text[50])
        {
            Caption = 'Device';
        }
        field(5; Payload; Text[2048])
        {
            Caption = 'Payload';
        }
        field(6; Description; Text[250])
        {
            Caption = 'Description';
        }
    }

    keys
    {
        key(pk; ID)
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; Name, Description)
        {
        }
    }
}