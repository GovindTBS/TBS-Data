// pageextension 50105 "Posted Item Tracking Lines" extends "Posted Item Tracking Lines"
// {
//     actions
//     {
//         addfirst(Promoted)
//         {
//             actionref(ViewLotInformation; "View Lot Information")
//             {

//             }
//         }
//         addlast(Navigation)
//         {
//             action("View Lot Information")
//             {
//                 ApplicationArea = All;
//                 Caption = 'View Lot Information';
//                 ToolTip = 'Opens the lot no information card with details.';
//                 Image = ViewDetails;

//                 trigger OnAction()
//                 var
//                     LotNoInformation: Record "Lot No. Information";
//                 begin
//                     LotNoInformation.Get(Rec."Item No.", Rec."Variant Code", Rec."Lot No.");
//                     Page.Run(Page::"Lot No. Information Card", LotNoInformation);
//                 end;
//             }
//         }
//     }
// }