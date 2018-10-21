Attribute VB_Name = "Module1"
Sub StockVolume():
    Dim lastRow As Double
    Dim sum As Double
    Dim rowTable As Double
    Dim yearOpen As Double
    Dim yearClose As Double
    Dim percentChange As Double
    Dim symPos As String
    Dim symNeg As String
    Dim symLrgVol As String
    Dim maxPosChange As Double
    Dim maxNegChange As Double
    Dim largestVolume As Double
        
    For Each ws In Worksheets
        
        rowTable = 2                'keeps track of summary table row
    
        ws.Cells(1, 9).Value = "Ticker"
        ws.Cells(1, 10).Value = "Yearly Change"
        ws.Cells(1, 11).Value = "Percent Change"
        ws.Cells(1, 12).Value = "Total Volume"
        ws.Cells(1, "O").Value = "Ticker"
        ws.Cells(1, "P").Value = "Value"
        ws.Cells(2, "N").Value = "Greatest % Increase"
        ws.Cells(3, "N").Value = "Greatest % Decrease"
        ws.Cells(4, "N").Value = "Greatest Total Volume"
    
        lastRow = ws.Cells(Rows.Count, 1).End(xlUp).Row
        sum = 0
        yearOpen = ws.Cells(2, 3).Value
    
        For i = 2 To lastRow         'iterates over all rows of data
            
            sum = sum + ws.Cells(i, 7).Value
        
            If (ws.Cells(i, 1).Value <> ws.Cells(i + 1, 1).Value) Then 'when ticker symbol changes, print out sum for stock
                
                yearClose = ws.Cells(i, 6).Value 'closing price on last instance of ticker symbol
                If yearOpen = 0 Then
                    percentChange = 0
                Else
                    percentChange = (yearClose - yearOpen) / yearOpen
                End If
                
                ws.Cells(rowTable, 9).Value = ws.Cells(i, 1).Value      'print out stock symbol
                ws.Cells(rowTable, 10).Value = yearClose - yearOpen     'print out annual change in price
                ws.Cells(rowTable, 11).Value = percentChange * 100 & "%" 'print out percentage change
                ws.Cells(rowTable, 12).Value = sum                      'print total volume traded
            
                rowTable = rowTable + 1     'resets variables after finding different stock symbol
                sum = 0
                yearOpen = ws.Cells(i + 1, 3).Value
                percentChange = 0
            
            ElseIf (ws.Cells(i, 2).Value = ws.Cells(i + 1, 2).Value) Then 'prevents double-counting of rows that have the same day
                sum = sum - ws.Cells(i, 7).Value
            
            End If
            
        Next i
    
        ' color-code positive year change and negative year change
        For i = 2 To rowTable - 1
            If ws.Cells(i, 10).Value > 0 Then
                ws.Cells(i, 10).Interior.ColorIndex = 4
            Else
                ws.Cells(i, 10).Interior.ColorIndex = 3
            End If
            
        Next i
        
    Next ws
    
    'print summary table for max percentage changes and largest volume traded on each worksheet
    For Each ws In Worksheets
        'searches summary table for largest percentage change, largest volume
        lastSummaryRow = ws.Cells(Rows.Count, 11).End(xlUp).Row
        largestVolume = 0
        maxPosChange = 0
        maxNegChange = 0

        For i = 2 To lastSummaryRow
            If ws.Cells(i, 11).Value > maxPosChange Then
                maxPosChange = ws.Cells(i, 11).Value
                symPos = ws.Cells(i, 9).Value
         
            ElseIf ws.Cells(i, 11).Value < maxNegChange Then
                maxNegChange = ws.Cells(i, 11).Value
                symNeg = ws.Cells(i, 9).Value
            
            End If
            
            If ws.Cells(i, 12) > largestVolume Then
                largestVolume = ws.Cells(i, 12)
                symLrgVol = ws.Cells(i, 9).Value
            End If
    
        Next i
        
        ws.Cells(2, "O").Value = symPos
        ws.Cells(2, "P").Value = Round(maxPosChange * 100, 0) & "%"
        ws.Cells(3, "O").Value = symNeg
        ws.Cells(3, "P").Value = Round(maxNegChange * 100, 0) & "%"
        ws.Cells(4, "O").Value = symLrgVol
        ws.Cells(4, "P").Value = largestVolume
        ws.Columns("A:P").EntireColumn.AutoFit
    
    Next ws
    
End Sub

