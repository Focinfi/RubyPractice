This project is a simple C-Lexer.
It can analysis:
  1. reserved word 
  2. IDentifier
  3. digital
  4. boundary
  5. operator

####Usage
  1. $ruby runner.rb
  2. Input C language code
  3. Type /END in a new line
  4. Output a list of "(category, 'word')"
  5. Create a src file and a res file 

####Example
Intput:
 
    int mian() {
      int a = 0;
      a++;    
    }
    /END  

Output:
    
    (1, 'int')
    (2, 'mian')
    (4, '(')
    (4, ')')
    (4, '{')
    (1, 'int')
    (2, 'a')
    (5, '=')
    (3, '0')
    (4, ';')
    (2, 'a')
    (5, '++')
    (4, ';')
    (4, '}') 












