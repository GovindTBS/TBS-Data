// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------
namespace System.Environment;

table 2000000140 "Event Subscription"
{
    DataPerCompany = false;
    Scope = Cloud;

    //WriteProtexted=True
    fields
    {
        field(1; "Subscriber Codeunit ID"; Integer)
        {
        }
        field(2; "Subscriber Function"; Text[250])
        {
        }
        field(3; "Event Type"; Option)
        {
            OptionMembers = Trigger,Business,Integration,Internal;
        }
        field(4; "Publisher Object Type"; Option)
        {
            OptionMembers = ,Table,,Report,,Codeunit,XMLport,,Page,Query,,;
        }
        field(5; "Publisher Object ID"; Integer)
        {
        }
        field(6; "Published Function"; Text[250])
        {
        }
        field(7; Active; Boolean)
        {
        }
        field(8; "Number of Calls"; BigInteger)
        {
        }
        field(9; "Error Information"; Text[250])
        {
        }
        field(10; "Originating Package ID"; Guid)
        {
        }
        field(11; "Originating App Name"; Text[250])
        {
        }
        field(12; "Subscriber Instance"; Text[250])
        {
        }
        field(13; "Active Manual Instances"; Integer)
        {
        }
    }

    keys
    {
        key(pk; "Subscriber Codeunit ID", "Subscriber Function")
        {

        }
    }
}