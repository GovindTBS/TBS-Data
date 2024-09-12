// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------
namespace System.Security.AccessControl;

using System.Environment.Configuration;

table 2000000189 "Tenant License State"
{
    Caption = 'Tenant License State';
    DataPerCompany = false;
    ReplicateData = false;
    Scope = Cloud;
    InherentPermissions = rX;

    fields
    {
        field(1; "Start Date"; DateTime)
        {
            Caption = 'Start Date';
        }
        field(2; "End Date"; DateTime)
        {
            Caption = 'End Date';
        }
        field(3; State; Option)
        {
            Caption = 'State';
            OptionCaption = 'Evaluation,Trial,Paid,Warning,Suspended,Deleted,,,,LockedOut';
            OptionMembers = Evaluation,Trial,Paid,Warning,Suspended,Deleted,,,,LockedOut;
        }
        field(4; "User Security ID"; Guid)
        {
            Caption = 'User Security ID';
            TableRelation = User."User Security ID";
        }
    }

    keys
    {
        key(Key1; "Start Date")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

