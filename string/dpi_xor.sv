import "DPI-C" function void str_concat(output string z, input string i0, i1);

program top;

typedef logic [63:0] lv64;
typedef bit [63:0] bv64;
typedef longint unsigned ulongint;



int mcd;

initial begin
    
    //mcd = $fopen("results.txt") | 1;
    string s1, s2, s3;
    s1 = "abc";
    s2 = "efg";

    s3 = {s1, s2};
    $display("s3 => %s", s3);
    
    s3 = "";
    str_concat(s3, s1, s2);
    $display("str_concat => %s", s3);

    //$fclose(mcd);

end

endprogram
