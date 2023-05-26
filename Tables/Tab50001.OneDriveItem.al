table 50001 "Online Drive Item"
{
    DataClassification = CustomerContent;

    fields
    {
        field(1; id; Text[250])
        {
            DataClassification = CustomerContent;
        }
        field(2; driveId; Text[250])
        {
            DataClassification = CustomerContent;
        }
        field(3; parentId; Text[250])
        {
            DataClassification = CustomerContent;
        }
        field(4; name; Text[250])
        {
            DataClassification = CustomerContent;
        }
        field(5; isFile; Boolean)
        {
            DataClassification = CustomerContent;
        }
        field(6; mimeType; Text[80])
        {
            DataClassification = CustomerContent;
        }
        field(7; size; BigInteger)
        {
            DataClassification = CustomerContent;
        }
        field(8; createdDateTime; DateTime)
        {
            DataClassification = CustomerContent;
        }
        field(9; webUrl; Text[250])
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; id)
        {
            Clustered = true;
        }
    }
    local procedure ReadDriveItems(JDriveItems: JsonArray; DriveID: Text; ParentID: Text; var DriveItem: Record "Online Drive Item")
    var
        JToken: JsonToken;
    begin
        foreach JToken in JDriveItems do
            ReadDriveItem(JToken.AsObject(), DriveID, ParentID, DriveItem);
    end;

    local procedure ReadDriveItem(
        JDriveItem: JsonObject;
        DriveID: Text;
        ParentID: Text;
        var DriveItem: Record "Online Drive Item")
    var
        JFile: JsonObject;
        JToken: JsonToken;
    begin

        DriveItem.Init();
        DriveItem.driveId := DriveID;
        DriveItem.parentId := ParentID;

        if JDriveItem.Get('id', JToken) then
            DriveItem.Id := JToken.AsValue().AsText();
        if JDriveItem.Get('name', JToken) then
            DriveItem.Name := JToken.AsValue().AsText();

        if JDriveItem.Get('size', JToken) then
            DriveItem.size := JToken.AsValue().AsBigInteger();

        if JDriveItem.Get('file', JToken) then begin
            DriveItem.IsFile := true;
            JFile := JToken.AsObject();
            if JFile.Get('mimeType', JToken) then
                DriveItem.mimeType := JToken.AsValue().AsText();
        end;
        if JDriveItem.Get('createdDateTime', JToken) then
            DriveItem.createdDateTime := JToken.AsValue().AsDateTime();
        if JDriveItem.Get('webUrl', JToken) then
            DriveItem.webUrl := JToken.AsValue().AsText();
        DriveItem.Insert();
    end;

}