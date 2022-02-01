# OMDBClient

A client framework for OMDBApi.com.

To get started, add the framework into your project and set the API key:
`OMDBClient.shared.apiKey = "..."`

The OMDBClient singleton (`OMDBClient.shared`) provides the following method to retrieve movies based on a search filter.
`public func fetchMovies(searchText: String, page: Int, completion: @escaping (OMDBResult) -> ())`

Query results are returned in groups of 10, indicated by a `page` number. Page 1 contains the first 10 results, Page 2 returns the next 10 results, and so on. Pass this value in as a parameter to sequentially load more results.

The `OMDBResult` object included in the callback is an enum with 2 cases:
- `.error`
- `.sucess(movies: [Movie], totalResults: Int)`
