// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------
namespace System.Integration;

table 2000000115 "Document Service Scenario"
{
    Caption = 'Document Sharing Scenario';
    DataPerCompany = false;
    ReplicateData = false;
    Scope = OnPrem;

    fields
    {
        field(1; "Service Integration"; Option)
        {
            OptionCaption = 'OneDrive';
            OptionMembers = "OneDrive";
            Caption = 'Service Integration';
            DataClassification = SystemMetadata;
        }
        field(2; "Company"; Guid)
        {
            Caption = 'Company';
            DataClassification = SystemMetadata;
        }
        field(3; "Document Service"; Code[30])
        {
            Caption = 'Document Service';
            DataClassification = SystemMetadata;
        }
        field(4; "Use for Application"; Boolean)
        {
            Caption = 'Use for Application';
            DataClassification = SystemMetadata;
        }
        field(5; "Use for Platform"; Boolean)
        {
            Caption = 'Use for Platform';
            DataClassification = SystemMetadata;
        }
    }

    keys
    {
        key(Key1; "Service Integration", "Company")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

