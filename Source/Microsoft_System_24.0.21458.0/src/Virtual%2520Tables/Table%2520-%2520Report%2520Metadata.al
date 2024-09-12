// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------
namespace System.Reflection;

table 2000000139 "Report Metadata"
{
    DataPerCompany = False;
    Scope = Cloud;
    //WriteProtected=True;
    InherentPermissions = rX;

    fields
    {
        field(1; ID; Integer)
        {
        }
        field(2; Name; Text[30])
        {
        }
        field(3; Caption; Text[80])
        {
        }
        field(4; UseRequestPage; Boolean)
        {
        }
        field(5; UseSystemPrinter; Boolean)
        {
        }
        field(6; EnableExternalImages; Boolean)
        {
        }
        field(7; EnableHyperLinks; Boolean)
        {
        }
        field(8; EnableExternalAssemblies; Boolean)
        {
        }
        field(9; ProcessingOnly; Boolean)
        {
        }
        field(10; ShowPrintStatus; Boolean)
        {
        }
        field(11; "TransactionType"; Option)
        {
            OptionMembers = UpdateNoLocks,Update,Snapshot,Browse,Report;
        }
        field(12; PaperSourceFirstPage; Integer)
        {
        }
        field(13; PaperSourceDefaultPage; Integer)
        {
        }
        field(14; PaperSourceLastPage; Integer)
        {
        }
        field(15; PreviewMode; Option)
        {
            OptionMembers = Normal,PrintLayout;
        }
        field(16; "DefaultLayout"; Option)
        {
            OptionMembers = RDLC,Word,Excel,Custom;
        }
        field(17; WordMergeDataItem; Text[250])
        {
        }
        field(18; FirstDataItemTableID; Integer)
        {
        }
        field(19; MaxRows; Integer)
        {
        }
        field(20; MaxDocuments; Integer)
        {
        }
        field(21; Timeout; Duration)
        {
        }
        field(22; AllowScheduling; Boolean)
        {
        }
        field(23; DefaultLayoutName; Text[100])
        {
        }
        field(24; FormatRegion; Text[80])
        {
        }
        field(25; ExcelLayoutMultipleDataSheets; Boolean)
        {
        }
    }
}