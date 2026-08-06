;;(module plugin.formatter {autoload {nvim aniseed.nvim formatter formatter}
;;                          require-macros [macros]})
;;
;;;;Register formatters into a table
;;(fn formatters.fnlfmt []
;;    "The Fennel Formatter"
;;    {:exe :fnlfmt :args [(nvim.buf_get_name 0)] :stdin true})
;;
;;;; Setup file formating
;;(formatter.setup {:filetype {:fennel [formatters.fnlfmt]}})
