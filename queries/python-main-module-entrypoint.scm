; Query to find Python main entry point pattern: if __name__ == "__main__":

((if_statement
  condition: (comparison_operator
    (identifier) @name
    (string) @main_string))
  (#eq? @name "__name__")
  (#eq? @main_string "\"__main__\""))