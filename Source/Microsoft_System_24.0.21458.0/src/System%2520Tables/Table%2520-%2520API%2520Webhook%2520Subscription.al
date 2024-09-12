// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------
namespace System.Integration;

using System.Security.AccessControl;

table 2000000095 "API Webhook Subscription"
{
    Caption = 'API Webhook Subscription';
    DataPerCompany = false;
    Scope = OnPrem;
    ReplicateData = false;

    fields
    {
        field(1; "Subscription Id"; Text[150])
        {
            Caption = 'Subscription Id';
        }
        field(2; "Entity Publisher"; Text[40])
        {
            Caption = 'Entity Publisher';
        }
        field(3; "Entity Group"; Text[40])
        {
            Caption = 'Entity Group';
        }
        field(4; "Entity Version"; Text[10])
        {
            Caption = 'Entity Version';
        }
        field(5; "Entity Set Name"; Text[250])
        {
            Caption = 'Entity Set Name';
        }
        field(6; "Company Name"; Text[30])
        {
            Caption = 'Company Name';
        }
        field(7; "Notification Url Blob"; BLOB)
        {
            Caption = 'Notification Url Blob';
        }
        field(8; "User Id"; Guid)
        {
            DataClassification = EndUserPseudonymousIdentifiers;
            Caption = 'User Id';
            TableRelation = User."User Security ID";
        }
        field(9; "Last Modified Date Time"; DateTime)
        {
            Caption = 'Last Modified Date Time';
        }
        field(10; "Client State"; Text[2048])
        {
            DataClassification = CustomerContent;
            Caption = 'Client State';
        }
        field(11; "Expiration Date Time"; DateTime)
        {
            Caption = 'Expiration Date Time';
        }
        field(12; "Resource Url Blob"; BLOB)
        {
            Caption = 'Resource Url Blob';
        }
        field(13; "Notification Url Prefix"; Text[250])
        {
            Caption = 'Notification Url Prefix';
        }
        field(14; "Source Table Id"; Integer)
        {
            Caption = 'Source Table Id';
        }
        field(15; "Subscription Type"; Option)
        {
            Caption = 'Subscription Type';
            OptionCaption = 'Regular,Dataverse';
            OptionMembers = Regular,Dataverse;
        }
    }

    keys
    {
        key(Key1; "Subscription Id")
        {
            Clustered = true;
        }
        key(Key2; "Notification Url Prefix")
        {
        }
        key(Key3; "Source Table Id", "Expiration Date Time", "Company Name")
        {
        }
        key(Key4; "Expiration Date Time", "Company Name")
        {
        }
    }

    fieldgroups
    {
    }
}

