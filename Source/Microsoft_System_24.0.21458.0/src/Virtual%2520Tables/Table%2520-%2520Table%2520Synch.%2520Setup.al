// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------
namespace System.Upgrade;

table 2000000135 "Table Synch. Setup"
{
    DataPerCompany = False;
    Scope = OnPrem;

    fields
    {
        field(1; "Table ID"; Integer)
        {
        }
        field(2; "Upgrade Table ID"; Integer)
        {
        }
        field(3; "Mode"; Option)
        {
            OptionMembers = Check,Copy,Move,Force;
        }
    }

    keys
    {
        key(pk; "Table ID")
        {
        }
    }
}