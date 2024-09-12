// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------
namespace System.Apps;

table 2000000244 "Extension Database Snapshot"
{
    Caption = 'Extension Database Snapshot';
    DataPerCompany = false;
    Scope = OnPrem;

    fields
    {
        field(1; "App Id"; Guid)
        {
            Caption = 'App ID';
        }

        field(2; "Package Id"; Guid)
        {
            Caption = 'Package Id';
        }

        field(3; "Name"; Text[80])
        {
            Caption = 'Name';
        }

        field(4; "Publisher"; Text[250])
        {
            Caption = 'Publisher';
        }

        field(5; "Schema Version"; Text[250])
        {
            Caption = 'Schema Version';
        }

        field(6; "Runtime Package Id"; Guid)
        {
            Caption = 'Runtime Package ID';
        }

        field(7; "Status"; Option)
        {
            Caption = 'Status';
            OptionCaption = 'Unpublished, Published, Installed';
            OptionMembers = "Unpublished","Published","Installed";
        }

        /// <summary>
        /// The "Published As" option. Indicates how the application was published.
        /// </summary>
        field(8; "Published As"; Option)
        {
            Caption = 'Published As';
            OptionCaption = 'Unpublished, Global, PTE, Dev';
            OptionMembers = "Unpublished","Global","PTE","Dev";
        }
    }

    keys
    {
        key(Key1; "App Id", "Package Id")
        {
            Clustered = true;
        }
    }
}

