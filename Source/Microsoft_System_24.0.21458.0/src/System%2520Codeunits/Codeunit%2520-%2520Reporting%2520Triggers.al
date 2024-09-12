// ------------------------------------------------------------------------------------------------
// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License. See License.txt in the project root for license information.
// ------------------------------------------------------------------------------------------------
namespace System.Environment;

codeunit 2000000005 "Reporting Triggers"
{
    SingleInstance = true;

    trigger OnRun()
    begin
    end;

    [BusinessEvent(false)]
    procedure GetPrinterName(ReportID: Integer; var PrinterName: Text[250])
    begin
    end;

    [BusinessEvent(false)]
    procedure GetFilename(ReportID: Integer; Caption: Text[250]; ObjectPayload: JsonObject; FileExtension: Text[30]; ReportRecordRef: RecordRef; var FileName: Text; var Success: Boolean)
    begin
    end;

    [BusinessEvent(false)]
    procedure GetPaperTrayForReport(ReportID: Integer; var FirstPage: Integer; var DefaultPage: Integer; var LastPage: Integer)
    begin
    end;

    [BusinessEvent(false)]
    procedure HasCustomLayout(ObjectType: Option "Report","Page"; ObjectID: Integer; var LayoutType: Option "None",RDLC,Word,Excel,Custom)
    begin
    end;

    [BusinessEvent(false)]
    procedure MergeDocument(ObjectType: Option "Report","Page"; ObjectID: Integer; ReportAction: Option SaveAsPdf,SaveAsWord,SaveAsExcel,Preview,Print,SaveAsHtml; XmlData: InStream; FileName: Text; var DocumentStream: OutStream)
    begin
    end;

    [BusinessEvent(false)]
    procedure CustomDocumentMerger(ObjectID: Integer; ReportAction: Option SaveAsPdf,SaveAsWord,SaveAsExcel,Preview,Print,SaveAsHtml; XmlData: InStream; LayoutData: InStream; var DocumentStream: OutStream)
    begin
    end;

    [BusinessEvent(false)]
    procedure CustomDocumentMergerEx(ObjectID: Integer; ReportAction: Option SaveAsPdf,SaveAsWord,SaveAsExcel,Preview,Print,SaveAsHtml; ObjectPayload: JsonObject; XmlData: InStream; LayoutData: InStream; var DocumentStream: OutStream; var Success: Boolean)
    begin
    end;

    [BusinessEvent(false)]
    procedure ReportGetCustomRdlc(ReportId: Integer; var RdlcText: Text)
    begin
    end;

    [BusinessEvent(false)]
    procedure ReportGetCustomWord(ReportId: Integer; var LayoutStream: OutStream; var Success: Boolean)
    begin
    end;

    [BusinessEvent(false)]
    procedure ScheduleReport(ReportId: Integer; RequestPageXml: Text; var Scheduled: Boolean)
    begin
    end;

    [BusinessEvent(false)]
    procedure SubstituteReport(ReportId: Integer; RunMode: Option Normal,ParametersOnly,Execute,Print,SaveAs,RunModal; RequestPageXml: Text; RecordRef: RecordRef; var NewReportId: Integer)
    begin
    end;

    [BusinessEvent(false)]
    procedure OnDocumentPrintReady(ObjectType: Option "Report","Page"; ObjectId: Integer; ObjectPayload: JsonObject; DocumentStream: InStream; var Success: Boolean)
    begin
    end;

    [BusinessEvent(false)]
    procedure OnDocumentReady(ObjectId: Integer; ObjectPayload: JsonObject; DocumentStream: InStream; var TargetStream: OutStream; var Success: Boolean)
    begin
    end;

    [BusinessEvent(false)]
    procedure OnIntermediateDocumentReady(ObjectId: Integer; ObjectPayload: JsonObject; DocumentStream: InStream; var TargetStream: OutStream; var Success: Boolean)
    begin
    end;

    [BusinessEvent(false)]
    procedure OnDocumentDownload(ObjectId: Integer; ObjectPayload: JsonObject; DocumentStream: InStream; var Success: Boolean)
    begin
    end;

    [BusinessEvent(false)]
    procedure SetupPrinters(var Printers: Dictionary of [Text[250], JsonObject])
    begin
    end;

    // Remaining events are internal events for providing backward compatibility for version 20 only.
    [BusinessEvent(false)]
    procedure SelectReportLayoutCode(ObjectId: Integer; var LayoutCode: Text; var LayoutType: Option "None",RDLC,Word,Excel,Custom; var Success: Boolean)
    begin
    end;

    [BusinessEvent(false)]
    procedure FetchReportLayoutByCode(ObjectId: Integer; LayoutCode: Text; var TargetStream: OutStream; var Success: Boolean)
    begin
    end;

    [BusinessEvent(false)]
    procedure ApplicationReportMergeStrategy(ObjectId: Integer; LayoutCode: Text; var InApplication: boolean)
    begin
    end;

    // Backward compatibility only. To be depricated when MergeDocument is removed
    [BusinessEvent(false)]
    procedure WordDocumentMergerAppMode(ObjectId: Integer; LayoutCode: Text; var InApplication: boolean)
    begin
    end;

    [BusinessEvent(false)]
    procedure SelectedBuiltinLayoutType(ObjectID: Integer; var LayoutType: Option "None",RDLC,Word,Excel,Custom)
    begin
    end;

    // Allows layout selection from the first party extension "Report Layouts"
    [BusinessEvent(false)]
    procedure SelectReportLayoutUI(ObjectId: Integer; var LayoutName: Text; var LayoutAppID: Guid; var Success: Boolean)
    begin
    end;

}

