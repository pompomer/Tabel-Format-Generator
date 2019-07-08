Attribute VB_Name = "Module1"
Sub TableGeneratorForTeX()
'�e��ϐ��̒�`
    Dim i As Integer
    Dim j As Integer
    Dim k As Integer
    Dim l As Integer
    Dim mem As Integer
    

'��A�s�A�v�f���̎擾
    Dim row As Integer
    row = Selection.Rows.Count
    
    Dim column As Integer
    column = Selection.Columns.Count
    
    Dim n As Integer
    n = row * column
    
'�Z���z��
    Dim cell_code() As String
    ReDim cell_code(n)
    
    Dim column_line() As Integer
    ReDim column_line(column + 1)
    
    Dim column_line_judge() As Integer
    ReDim column_line_judge(n + row)
    
    Dim cell_line_l() As String
    ReDim cell_line_l(n + row)
    
    Dim cell_pos() As String
    ReDim cell_pos(n + row)
    
    Dim column_pos() As String
    ReDim column_pos(column)
    
    
'�e�Z���̈ʒu�����擾
    For i = 0 To (row - 1)
    
        For j = 0 To (column - 1)
        
            If Selection(column * i + j + 1).HorizontalAlignment = xlLeft Then
                cell_pos(column * i + j) = "l"
                
            ElseIf Selection(column * i + j + 1).HorizontalAlignment = xlCenter Then
                cell_pos(column * i + j) = "c"
                
            Else
                cell_pos(column * i + j) = "r"
            End If

        Next j
        
    Next i
    
'�e��̈ʒu���������
    For i = 0 To (column - 1)
    
        For j = 0 To (row - 1)
            
            If cell_pos(column * j + i) = "r" Then
                
                column_pos(i) = "r"
                Exit For
            End If
                
            column_pos(i) = cell_pos(column * j + i)

        Next j
        
    Next i
    
    
'�c���̗L���擾
    For i = 0 To (row - 1)
    
        If Not Selection(column * i + 1).Borders(xlEdgeLeft).LineStyle = xlLineStyleNone Then
            cell_line_l((column + 1) * i) = "|"
            
        Else
            cell_line_l((column + 1) * i) = ""
        End If
    Next i

    For i = 0 To (row - 1)
    
        For j = 0 To (column - 1)
            If Not Selection(column * i + j + 1).Borders(xlEdgeRight).LineStyle = xlLineStyleNone Then
                cell_line_l((column + 1) * i + j + 1) = "|"
            Else
                cell_line_l((column + 1) * i + j + 1) = ""
            End If
        Next j
        
    Next i
    
    
'�ȍ~�A�R�[�h����
    Dim code As String
    code = "\begin{table}[h]" + vbCrLf + "\caption{}" + vbCrLf + "\label{}" + vbCrLf + "\centering" + vbCrLf + "\begin{tabular}{"
    
    
'tabular�̃I�v�V��������
    '���[�̏c�r���̗L������
    For i = 0 To (row - 1)
    
        If Not Selection(column * i + 1).Borders(xlEdgeLeft).LineStyle = xlLineStyleNone Then
            code = code + "|"
            column_line(0) = 1
            Exit For
        End If
        
        column_line(0) = 0
        
    Next i
    
    '�e��E�[�̏c�r���̗L������
    For i = 0 To (column - 1)
        code = code + column_pos(i)
        
        For j = 0 To (row - 1)
        
            If Not Selection(column * j + i + 1).Borders(xlEdgeRight).LineStyle = xlLineStyleNone Then
                code = code + "|"
                column_line(i + 1) = 1
                Exit For
            End If
            
            column_line(i + 1) = 0
            
        Next j
        
    Next i
    
    code = code + "}" + vbCrLf
    
    
'�\�̍ŏ㕔�̉��r���̗L������
    For i = 0 To (column - 1)
    
        If Not Selection(i + 1).Borders(xlEdgeTop).LineStyle = xlLineStyleNone Then
            mem = i
            
            For k = i To (column - 1)
                
                If Selection(k + 1).Borders(xlEdgeTop).LineStyle = xlLineStyleNone Then
                    code = code + "\cline{" + Trim(str(mem + 1)) + "-" + Trim(str(k)) + "}"
                    Exit For
                End If
                
                If Not Selection(column).Borders(xlEdgeTop).LineStyle = xlLineStyleNone Then
                
                    If k = column - 1 Then
                        code = code + "\cline{" + Trim(str(mem + 1)) + "-" + Trim(str(column)) + "}"
                    End If
                    
                End If
                
            Next k
            
            i = k
            
        End If
        
    Next i
    
    code = code + vbCrLf
    
'�r���̗L������ 1��ڂƑ��̗�ŏ�������

    '1��ڂ̏���
    For i = 0 To (row - 1)
    
        If Not Selection(column * i + 1).Borders(xlEdgeLeft).LineStyle = xlLineStyleNone Then
            column_line_judge((column + 1) * i) = 1
            
        Else
            column_line_judge((column + 1) * i) = 0
        End If
        
    Next i
    
    '���̗�̏���
    For i = 0 To (row - 1)
    
        For j = 1 To column
        
            If Not Selection(column * i + j).Borders(xlEdgeRight).LineStyle = xlLineStyleNone Then
                column_line_judge((column + 1) * i + j) = 1
                
            Else
                column_line_judge((column + 1) * i + j) = 0
            End If
            
        Next j
        
    Next i
    
    
'�e�Z���̃R�[�h���� 1��ڂƑ��̗�ŏ�������

    '1��ڂ̏���
    For i = 0 To (row - 1)
    
        If Selection(column * i + 1).MergeCells Then
        
            If Selection(column * i + 1).MergeArea.Rows.Count = 1 Then
                cell_code(column * i) = "\multicolumn{" + Trim(Selection(column * i + 1).MergeArea.Columns.Count) + "}{" + cell_line_l((column + 1) * i) + cell_pos(column * i) + cell_line_l((column + 1) * i + Selection(column * i + 1).MergeArea.Columns.Count) + "}{" + Trim(Selection(column * i + 1).Value) + "}"
            
            Else
            
                If Selection(column * i + 1).MergeArea.Item(1).Address = Selection(column * i + 1).Address Then
                    cell_code(column * i) = "\multicolumn{" + Trim(Selection(column * i + 1).MergeArea.Columns.Count) + "}{" + cell_line_l((column + 1) * i) + cell_pos(column * i) + cell_line_l((column + 1) * i + Selection(column * i + 1).MergeArea.Columns.Count) + "}{" + "\multirow{" + Trim(Selection(column * i + 1).MergeArea.Rows.Count) + "}{*}{" + Trim(Selection(column * i + 1).Value) + "}}"
                
                ElseIf Selection(column * i + 1).MergeArea.Item(1).column = Selection(column * i + 1).column Then
                    cell_code(column * i) = "\multicolumn{" + Trim(Selection(column * i + 1).MergeArea.Columns.Count) + "}{" + cell_line_l((column + 1) * i) + cell_pos(column * i) + cell_line_l((column + 1) * i + Selection(column * i + 1).MergeArea.Columns.Count) + "}{}"
                
                Else
                    cell_code(column * i) = ""
                End If
                
            End If
        
        Else
        
            If ((column_line_judge((column + 1) * i) Xor column_line(0)) = 1) Or ((column_line_judge((column + 1) * i + 1) Xor column_line(1)) = 1) Then
                cell_code(column * i) = "\multicolumn{" + "1" + "}{" + cell_line_l((column + 1) * i) + cell_pos(column * i) + cell_line_l((column + 1) * i + 1) + "}{" + Trim(Selection(column * i + 1).Value) + "}"
            
            ElseIf Not cell_pos(column * i) = column_pos(0) Then
                cell_code(column * i) = "\multicolumn{" + "1" + "}{" + cell_line_l((column + 1) * i) + cell_pos(column * i) + cell_line_l((column + 1) * i + 1) + "}{" + Trim(Selection(column * i + 1).Value) + "}"
                
            Else
                cell_code(column * i) = Trim(Selection(column * i + 1).Value)
            End If
        End If
        
    Next i
    
    
    '���̗�̏���
        '�Z����������
    For i = 0 To (row - 1)
        
        For j = 1 To (column - 1)
        
            If Selection(column * i + j + 1).MergeCells Then
            
                If Selection(column * i + j + 1).MergeArea.Rows.Count = 1 Then
                    
                    If Selection(column * i + j + 1).MergeArea.Item(1).Address = Selection(column * i + j + 1).Address Then
                        cell_code(column * i + j) = "\multicolumn{" + Trim(Selection(column * i + j + 1).MergeArea.Columns.Count) + "}{" + cell_line_l((column + 1) * i + j) + cell_pos(column * i + j) + cell_line_l((column + 1) * i + j + Selection(column * i + j + 1).MergeArea.Columns.Count) + "}{" + Trim(Selection(column * i + j + 1).Value) + "}"
                    Else
                        cell_code(column * i + j) = ""
                    End If
                Else
                    
                    If Selection(column * i + j + 1).MergeArea.Item(1).Address = Selection(column * i + j + 1).Address Then
                        cell_code(column * i + j) = "\multicolumn{" + Trim(Selection(column * i + j + 1).MergeArea.Columns.Count) + "}{" + cell_line_l((column + 1) * i + j) + cell_pos(column * i + j) + cell_line_l((column + 1) * i + j + Selection(column * i + j + 1).MergeArea.Columns.Count) + "}{" + "\multirow{" + Trim(Selection(column * i + j + 1).MergeArea.Rows.Count) + "}{*}{" + Trim(Selection(column * i + j + 1).Value) + "}}"
                    
                    ElseIf Selection(column * i + j + 1).MergeArea.Item(1).column = Selection(column * i + j + 1).column Then
                        cell_code(column * i + j) = "\multicolumn{" + Trim(Selection(column * i + j + 1).MergeArea.Columns.Count) + "}{" + cell_line_l((column + 1) * i + j) + cell_pos(column * i + j) + cell_line_l((column + 1) * i + j + Selection(column * i + j + 1).MergeArea.Columns.Count) + "}{}"
                    
                    Else
                        cell_code(column * i + j) = ""
                    
                    End If
                End If
                
            Else
            
                If ((column_line_judge((column + 1) * i + j) Xor column_line(j)) = 1) Or ((column_line_judge((column + 1) * i + j + 1) Xor column_line(j + 1)) = 1) Then
                    cell_code(column * i + j) = "\multicolumn{" + "1" + "}{" + cell_line_l((column + 1) * i + j) + cell_pos(column * i + j) + cell_line_l((column + 1) * i + j + 1) + "}{" + Trim(Selection(column * i + j + 1).Value) + "}"
                    
                ElseIf Not cell_pos(column * i + j) = column_pos(j) Then
                    cell_code(column * i + j) = "\multicolumn{" + "1" + "}{" + cell_line_l((column + 1) * i + j) + cell_pos(column * i + j) + cell_line_l((column + 1) * i + j + 1) + "}{" + Trim(Selection(column * i + j + 1).Value) + "}"
                
                Else
                    cell_code(column * i + j) = Trim(Selection(column * i + j + 1).Value)
                End If
            End If
            
        Next j

    Next i
    
    '�e�Z���̕����񒷂��̓���
        Dim max_str As Integer
        
    For i = 0 To (column - 1)
        max_str = LenB(StrConv(cell_code(i), vbFromUnicode))
        
        For j = 0 To (row - 1)
        
            If (max_str < LenB(StrConv(cell_code(column * j + i), vbFromUnicode))) Then
                max_str = LenB(StrConv(cell_code(column * j + i), vbFromUnicode))
            End If
            
        Next j
        
        For j = 0 To (row - 1)
        
            While LenB(StrConv(cell_code(column * j + i), vbFromUnicode)) < max_str
                cell_code(column * j + i) = " " + cell_code(column * j + i)
            Wend
            cell_code(column * j + i) = cell_code(column * j + i)
        Next j
        
    Next i
    
    '�R�[�h����
    For i = 0 To (row - 1)
        '�Z���ƃR�[�h�̍���
        For j = 0 To (column - 2)
            If (Selection(column * i + j + 1).MergeArea.Columns.Count = 1) Or (Selection(column * i + j + 1).MergeArea.Item(Selection(column * i + j + 1).MergeArea.Count).column = Selection(column * i + j + 1).column) Then
                code = code + cell_code(column * i + j) + " & "
            Else
                code = code + cell_code(column * i + j) + "   "
            End If
        Next j
        
        code = code + cell_code(column * i + (column - 1)) + " \\"
        
        'cline�̍���
        For j = 0 To (column - 1)
            
            If Not (Selection(column * i + j + 1).Borders(xlEdgeBottom).LineStyle = xlLineStyleNone) Then
                
                If (Selection(column * i + j + 1).MergeArea.Item(Selection(column * i + j + 1).MergeArea.Count).row = Selection(column * i + j + 1).row) Then
                    mem = j
                
                    For k = j To (column - 1)
                        If (Selection(column * i + k + 1).Borders(xlEdgeBottom).LineStyle = xlLineStyleNone) Or (Not Selection(column * i + k + 1).MergeArea.Item(Selection(column * i + k + 1).MergeArea.Count).row = Selection(column * i + k + 1).row) Then
                            code = code + "\cline{" + Trim(str(mem + 1)) + "-" + Trim(str(k)) + "}"
                            Exit For
                        End If
                    
                        If Not Selection(column * i + column).Borders(xlEdgeBottom).LineStyle = xlLineStyleNone Then
                        
                            If k = (column - 1) Then
                                code = code + "\cline{" + Trim(str(mem + 1)) + "-" + Trim(str(column)) + "}"
                            End If
                        
                        End If
                    
                    Next k

                    j = k

                End If

            End If
            
        Next j
        
        code = code + vbCrLf
        
    Next i
    
    code = code + "\end{tabular}" + vbCrLf + "\end{table}"

    
'�R�[�h�o��
    Dim fso As FileSystemObject
    Set fso = New FileSystemObject

    Dim s As String
    
    s = fso.GetBaseName(ActiveWorkbook.FullName)
    
    Debug.Print s
    
    Dim file As String
    file = ActiveWorkbook.Path & "\" & s & "_TeX.txt"
    Open file For Output As #1
    
    Print #1, code
    
    Close #1
    
    MsgBox "Output to '" & s & "_TeX.txt' is done"
End Sub
    
