// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------
namespace System.Integration;

table 2000000114 "Document Service"
{
    Caption = 'Document Service';
    DataPerCompany = false;
    ReplicateData = false;
    Scope = OnPrem;

    fields
    {
        field(1; "Service ID"; Code[30])
        {
            Caption = 'Service ID';
        }
        field(3; Description; Text[80])
        {
            Caption = 'Description';
        }
        field(5; Location; Text[250])
        {
            Caption = 'Location';
        }
        field(7; "User Name"; Text[128])
        {
            Caption = 'User Name';
        }
        field(9; Password; Text[128])
        {
            Caption = 'Password';
            ExtendedDatatype = Masked;
        }
        field(11; "Document Repository"; Text[250])
        {
            Caption = 'Document Repository';
        }
        field(13; Folder; Text[250])
        {
            Caption = 'Folder';
        }
        field(15; "Client Id"; Text[250])
        {
            Caption = 'Client Id';
        }
        field(17; "Client Secret"; Text[250])
        {
            Caption = 'Client Secret';
            ObsoleteReason = 'Unused field.';
            ObsoleteState = Pending;
            ObsoleteTag = '17.0';
        }
        field(19; "Redirect URL"; Text[2048])
        {
            Caption = 'Redirect URL';
        }
        field(21; "Authentication Type"; Option)
        {
            Caption = 'Authentication Type';
            OptionCaption = 'Legacy,OAuth2';
            OptionMembers = Legacy,OAuth2;
        }
        field(23; "Client Secret Key"; Guid)
        {
            Caption = 'Client Secret Key';
        }
    }

    keys
    {
        key(Key1; "Service ID")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Service ID", Description)
        {
        }
    }
}

