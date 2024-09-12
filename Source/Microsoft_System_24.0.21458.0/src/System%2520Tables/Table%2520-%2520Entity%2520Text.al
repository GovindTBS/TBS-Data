// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------
namespace System.Text;

table 2000000132 "Entity Text"
{
    ReplicateData = false;

    fields
    {
        field(1; Company; Text[30])
        {
            DataClassification = SystemMetadata;
            TableRelation = System.Environment.Company.Name;
        }

        field(2; "Source Table Id"; Integer)
        {
            DataClassification = SystemMetadata;
        }

        field(3; "Source System Id"; Guid)
        {
            DataClassification = SystemMetadata;
        }

        field(4; Scenario; Enum "Entity Text Scenario")
        {
            DataClassification = SystemMetadata;
        }

        field(5; "Preview Text"; Text[1024])
        {
            DataClassification = CustomerContent;
        }

        field(6; Text; Blob)
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; Company, "Source Table Id", "Source System Id", Scenario)
        {
            Clustered = true;
        }
    }
}