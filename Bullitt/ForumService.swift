//
//  ForumService.swift
//  Bullitt
//
//  Copyright (c) 2015 Chris Haugli. All rights reserved.
//

import Foundation

protocol ForumService {
    
    /**
    Fetches the list of forums, including all subforums.
    
    :param: success The block called when the fetch succeeds.
    :param: failure The block called when the fetch fails.
    */
    func listForums(success: (forums: [Forum]) -> (), failure: (error: NSError) -> ())
    
    /**
    Loads a page of threads for a given forum.
    
    :param: forum       The forum to load threads for.
    :param: perPage     The number of threads to request per page.
    :param: pageNumber  The page number to request.
    :param: success     The block called when the page load succeeds.
    :param: failure     The block called when the page load fails.
    */
    func loadThreads(forum: Forum, perPage: Int, pageNumber: Int, success: (threads: [Thread]) -> (), failure: (error: NSError) -> ())

    /**
    Loads a page of posts for a given thread.
    
    :param: thread      The thread to load posts for.
    :param: pageNumber  The page number to request.
    :param: success     The block called when the page load succeeds.
    :param: failure     The block called when the page load fails.
    */
    func loadPosts(thread: Thread, pageNumber: Int, success: (posts: [Post]) -> (), failure: (error: NSError) -> ())
}
