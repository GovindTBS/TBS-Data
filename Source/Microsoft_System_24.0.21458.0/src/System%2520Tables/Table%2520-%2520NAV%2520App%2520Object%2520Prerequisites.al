// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------
namespace System.Apps;

table 2000000163 "NAV App Object Prerequisites"
{
    Caption = 'NAV App Object Prerequisites';
    DataPerCompany = false;
    ReplicateData = false;
    Scope = OnPrem;

    fields
    {
        field(1; "Package ID"; Guid)
        {
            Caption = 'Package ID';
        }
        field(2; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = 'TableData,Table,,Report,,Codeunit,XMLport,MenuSuite,Page,Query';
            OptionMembers = TableData,"Table",,"Report",,"Codeunit","XMLport",MenuSuite,"Page","Query";
        }
        field(3; ID; Integer)
        {
            Caption = 'ID';
        }
    }

    keys
    {
        key(Key1; "Package ID", Type, ID)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

