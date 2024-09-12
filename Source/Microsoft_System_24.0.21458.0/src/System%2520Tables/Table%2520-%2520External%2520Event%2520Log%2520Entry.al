// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------
namespace System.Integration;

using System.Security.AccessControl;

table 2000000241 "External Event Log Entry"
{
    Caption = 'External Event Log Entry';
    DataPerCompany = false;
    ReplicateData = false;
    Scope = OnPrem;

    fields
    {
        field(1; "ID"; Integer)
        {
            AutoIncrement = true;
            Caption = 'ID';
        }
        field(2; "App Id"; Guid)
        {
            Caption = 'App Id';
        }
        field(3; "App Version"; Text[43])
        {
            Caption = 'App Version';
        }
        field(4; "Event Name"; Text[80])
        {
            Caption = 'Event Name';
        }
        field(5; "Company Name"; Text[30])
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Company Name';
        }
        field(6; "User Id"; Guid)
        {
            DataClassification = EndUserPseudonymousIdentifiers;
            Caption = 'User Id';
            TableRelation = User."User Security ID";
        }
        field(7; "Event Date Time"; DateTime)
        {
            Caption = 'Event Date Time';
        }
        field(8; "Event Payload Blob"; BLOB)
        {
            Caption = 'Event Payload Blob';
        }
        field(9; "Processed"; Boolean)
        {
            Caption = 'Processed';
        }
        field(10; "Company Id"; Guid)
        {
            DataClassification = OrganizationIdentifiableInformation;
            Caption = 'Company Id';
        }

        /// <summary>
        /// The evnet version set in the event decleration.
        /// </summary>
        field(11; "Event Version"; Text[43])
        {
            Caption = 'Event Version';
        }
    }

    keys
    {
        key(Key1; "ID")
        {
            Clustered = true;
        }
        key(Key2; "Processed")
        {
        }
    }

    fieldgroups
    {
    }
}

