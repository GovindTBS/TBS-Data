// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------
namespace System.Environment.Configuration;

table 2000000230 "Page Usage State"
{
    Caption = 'Page Usage State';
    DataPerCompany = false;
    Scope = OnPrem;
    ReplicateData = false;

    fields
    {
        field(1; "User ID"; Guid)
        {
            Caption = 'User ID';
        }
        field(2; "Page ID"; Integer)
        {
            Caption = 'Object ID';
        }
        field(3; "Page Type"; Option)
        {
            Caption = 'Object Type';
            OptionMembers = "Page","RequestPage","PageType","SystemPage";
            OptionCaption = 'Page,RequestPage,PageType,SystemPage';
        }
        field(4; "Tour Dismissed"; Boolean)
        {
            Caption = 'Tour Dismissed';
        }
        field(5; "Tour Completed"; Boolean)
        {
            Caption = 'Tour Completed';
        }
        field(6; "System Tour Completed"; Boolean)
        {
            Caption = 'System Tour Completed';
        }
    }

    keys
    {
        key(Key1; "User ID", "Page ID", "Page Type")
        {
            Clustered = true;
        }
    }
}
