// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------
namespace System.Security;

using System.Environment;
using System.Security.AccessControl;

table 2000000107 "Isolated Storage"
{
    Caption = 'Isolated Storage';
    DataPerCompany = false;
    Scope = OnPrem;
    ReplicateData = false;

    fields
    {
        field(1; "App Id"; Guid)
        {
            Caption = 'App Id';
        }

        field(2; Scope; Option)
        {
            Caption = 'Scope';
            OptionCaption = 'Module,Company,User,CompanyAndUser';
            OptionMembers = Module,Company,User,CompanyAndUser;
        }

        field(3; "Company Name"; Text[30])
        {
            Caption = 'Company Name';
            TableRelation = Company.Name;
        }

        field(4; "User Id"; Guid)
        {
            Caption = 'User Id';
            TableRelation = User."User Security ID";
            DataClassification = EndUserIdentifiableInformation;
            //This property is currently not supported
            //TestTableRelation = false;
        }

        field(5; "Key"; Text[200])
        {
            DataClassification = CustomerContent;
            Caption = 'Key';
        }

        field(6; Value; BLOB)
        {
            DataClassification = CustomerContent;
            Caption = 'Value';
        }

        field(7; "Encryption Status"; Option)
        {
            Caption = 'Encryption Status';
            OptionCaption = 'PlainText,Encrypted,PendingForEncryption';
            OptionMembers = PlainText,Encrypted,PendingForEncryption;
        }

        field(8; "Target Value Type"; Option)
        {
            Caption = 'Target Value Type';
            OptionCaption = 'Text,SecretText';
            OptionMembers = Text,SecretText;
        }
    }

    keys
    {
        key(Key1; "App Id", Scope, "Company Name", "User Id", "Key")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

