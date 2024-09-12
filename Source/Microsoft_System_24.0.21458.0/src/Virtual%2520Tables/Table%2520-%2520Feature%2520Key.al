// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------
namespace System.Environment.Configuration;

table 2000000211 "Feature Key"
{
    Caption = 'Feature Key';
    DataPerCompany = false;
    Scope = Cloud;

    fields
    {
        field(1; ID; Text[50])
        {
            Caption = 'ID';
        }
        field(2; Enabled; Option)
        {
            Caption = 'Enabled';
            OptionCaption = 'None,All Users';
            OptionMembers = "None","All Users";
        }
        field(3; Description; Text[2048])
        {
            Caption = 'Description';
        }
        field(4; "Learn More Link"; Text[2048])
        {
            Caption = 'Learn more';
        }
        field(5; "Mandatory By"; Text[2048])
        {
            Caption = 'Approximate mandatory date';
        }
        field(6; "Can Try"; boolean)
        {
            Caption = 'Get started';
        }
        field(7; "Is One Way"; Boolean)
        {
            Caption = 'Is One Way';
        }
        field(8; "Data Update Required"; Boolean)
        {
            Caption = 'Data Update Required';
        }
        field(9; "Mandatory By Version"; Text[2048])
        {
            Caption = 'Approximate mandatory version';
        }
        field(10; "Description In English"; Text[2048])
        {
            Caption = 'Description In English';
        }
    }

    keys
    {
        key(Key1; ID)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

