<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="fileupload.aspx.cs" Inherits="JobyCoWebCustomize.fileupload" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <script src="/js/jquery-2.2.4.min.js"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            //$('#btnUpload').click(function () {
            //    var files = $('#FileUpload1')[0].files;

            //    if (files.length > 0) {
            //        var formData = new FormData();
            //        for (var i = 0; i < files.length; i++) {
            //            formData.append(files[i].name, files[i]);
            //        }

            //        $.ajax({
            //            url: 'UploadHandler.ashx',
            //            method: 'post',
            //            data: formData,
            //            contentType: false,
            //            processData: false,
            //            success: function () {
            //                alert("Success")
            //            },
            //            error: function (err) {
            //                alert(err.statusText)
            //            }
            //        });
            //    }
            //});
        });

        function getRows() {
            $("#myTable tbody > tr").each(function () {
                var vUploadId = $(this).closest('tr').find("input[type=file]").attr('id');

                files = $('#' + vUploadId)[0].files;
                if (files.length > 0) {
                    var formData = new FormData();
                    for (var i = 0; i < files.length; i++) {
                        formData.append(files[i].name, files[i]);
                    }
                };
                alert(files[0].name);
            });
        }

        var counter = 2;
        function addRows() {
            var vHTML = '<tr><td>64</td><td>Stationary</td><td>111</td><td><input type="file" name="file" id="FileUpload' + counter + '" /></td></tr>';
            $("#myTable tbody").append(vHTML);
            counter++;

            return false;
        }
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <div>
                <!--<label for="fileUpload"></label>
                Select File to Upload:
                <input type="file" name="file" id="FileUpload1" />
                <input type="button" id="btnUpload" value="Upload Files" />-->

                <button onclick="return addRows();">Add Rows</button>
                <table id="myTable">
                <tbody>
                    <tr>
                        <td>63</td>
                        <td>Computer</td>
                        <td>3434</td>
                        <td>
                            <input type="file" name="file" id="FileUpload1" />
                        </td>
                    </tr>
                </tbody>            
                </table>
                <button onclick="getRows();">Get Rows</button>
            </div>
        </div>
    </form>
</body>
</html>
