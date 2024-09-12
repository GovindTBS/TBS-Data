// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------
namespace System.Integration;

using System.Environment;
using System.Security.AccessControl;

table 2000000240 "External Event Subscription"
{
    Caption = 'External Event Subscription';
    DataPerCompany = false;
    ReplicateData = false;
    Scope = OnPrem;

    fields
    {
        field(1; "ID"; Guid)
        {
            Caption = 'ID';
        }
        field(2; "App Id"; Guid)
        {
            Caption = 'App Id';
        }
        field(3; "Event Name"; Text[80])
        {
            Caption = 'Event Name';
        }
        field(4; "Company Name"; Text[30])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Company Name';
            TableRelation = Company.Name;
        }
        field(5; "User Id"; Guid)
        {
            DataClassification = EndUserPseudonymousIdentifiers;
            Caption = 'User Id';
            TableRelation = User."User Security ID";
        }
        field(6; "Notification Url"; Text[2048])
        {
            Caption = 'Notification Url';
        }
        field(7; "Last Modified Date Time"; DateTime)
        {
            Caption = 'Last Modified Date Time';
        }
        field(8; "Client State"; Text[2048])
        {
            DataClassification = CustomerContent;
            Caption = 'Client State';
        }
        field(9; "Subscription Type"; Option)
        {
            Caption = 'Subscription Type';
            OptionCaption = 'Dataverse,Webhook';
            OptionMembers = Dataverse,Webhook;
        }

        /// <summary>
        /// The event version set in the event declaration.
        /// </summary>
        field(10; "Event Version"; Text[43])
        {
            Caption = 'Event Version';
        }

        /// <summary>
        /// The subscription state - active or disabled.
        /// </summary>
        field(11; "Subscription State"; Option)
        {
            Caption = 'Subscription State';
            OptionCaption = 'Active,Disabled';
            OptionMembers = Active,Disabled;
        }
    }

    keys
    {
        key(Key1; "ID")
        {
            Clustered = true;
        }
        key(Key2; "App Id", "Event Name")
        {
        }
        key(Key3; "Subscription State")
        {
        }
    }

    fieldgroups
    {
    }
}

