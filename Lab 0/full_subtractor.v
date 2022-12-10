`timescale 1ns / 1ps

module Full_Subtractor(
    In_A, In_B, Borrow_in, Difference, Borrow_out
    );
    input In_A, In_B, Borrow_in;
    output Difference, Borrow_out;
    wire D1, Bout1, Bout2;
    
    // implement full subtractor circuit, your code starts from here.
    // use half subtractor in this module, fulfill I/O ports connection.
    Half_Subtractor HSUB1 (
        .In_A(In_A), 
        .In_B(In_B), 
        .Difference(D1), 
        .Borrow_out(Bout1)
    );
    
    Half_Subtractor HSUB2 (
        .In_A(D1),
        .In_B(Borrow_in),
        .Difference(Difference),
        .Borrow_out(Bout2)
    );
    
    or(Borrow_out, Bout1, Bout2);
    
endmodule
