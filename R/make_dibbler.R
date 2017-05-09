#' Process input data for dibbler
#'
#' This function combines data of a food distribution network (including cases
#' as terminal nodes) and additional information on the nodes (typically a
#' linelist) to create a \code{dibbler} object. The S3 class \code{dibbler} is
#' an extension of the \code{epicontacts} objects implemented in the similarly
#' named package.
#'
#' @author Thibaut Jombart \email{thibautjombart@@gmail.com}
#'
#' @export
#'
#' @return a list of data suitable for input for \code{\link{dibbler}}
#'
#' @param net A \code{data.frame} defining the edges of the food distribution
#' network with at least two columns representing source and receiver nodes
#' (i.e., 'from' and 'to'). This network is meant to include cases, which will
#' be seen as terminal nodes. Labels used in these columns will be matched
#' against \code{nodes_data}. Other columns are optional and will be kept as
#' edge attributes.
#'
#' @param nodes_data A \code{data.frame} containing additional information on
#' the nodes of the network. Typically, this will be a linelist providing data
#' on the reported cases.
#'
#' @param from An integer or character string indicating the column in
#' \code{net} containing source nodes ('from' column).
#' 
#' @param to An integer or character string indicating the column in
#' \code{net} containing receiving nodes ('to' column).
#' 
#' @param id An integer or character string indicating the column in
#' \code{nodes_data} containing unique case identifiers. These will be matched
#' against the nodes of the network described in \code{net}.
#'
#' @examples
#' 
#' if (require(outbreaks)) {
#' 
#'   v_data <- s_enteritidis_pt59$graph
#'   n_data <- data.frame(id = names(s_enteritidis_pt59$cluster),
#'                        cluster = s_enteritidis_pt59$cluster)
#'
#'   x <- make_dibbler(v_data, n_data)
#'   x
#' }


## This constructor relies on making an 'epicontacts' object, and then adding
## some information specific to 'dibbler' objects (which extend
## 'epicontacts'). These additions include:

## - the type of nodes of the network: 'entry' (in degree 0, out degree >= 1);
## 'terminal (in degree >= 1, out degree 0); 'internal' (all others)


make_dibbler <- function(net, nodes_data, from = 1L, to = 2L, id = 1L) {

    out <- epicontacts::make_epicontacts(nodes_data, net,
                                         from = from, to = to,
                                         directed = TRUE)
    
    if ("node_type" %in% names(out$linelist)) {
        msg <- "A column 'node_type' exists in nodes_data and will be erased."
        warning(msg)
    }


    ## determine the type of nodes: entry, internal, or terminal
    
    ids <- get_id(out, "contacts")
    supp_node_data <- data.frame(id = ids,
                                 stringsAsFactors = FALSE)
    in_deg <- get_degree(x, "in")
    out_deg <- get_degree(x, "out")
    entry <- names(which(in_deg == 0L & out_deg > 0))
    terminal <- names(which(in_deg > 0 & out_deg == 0L))
    node_type <- rep("internal", nrow(supp_node_data))
    node_type[ids %in% entry] <- "entry"
    node_type[ids %in% terminal] <- "terminal"
    supp_node_data$node_type <- node_type

    out$linelist <- merge(out$linelist,
                          supp_node_data,
                          by = "id", all = TRUE)
    
    class(out) <- c("dibbler", "epicontacts")
    return(out)
}