//
//  PostCommentsPresenter.swift
//  PostConsumer
//
//  Created by Kelvin Lima on 29/04/20.
//  Copyright © 2020 UnB. All rights reserved.
//

import Foundation

class PostCommentsPresenter
{
    weak var view: PostCommentsViewProtocol?
    private let _getPostCommentsInteractor: GetPostCommentsInteractor
    private let _post: PostModel

    init(post: PostModel, getPostCommentsInteractor: GetPostCommentsInteractor)
    {
        _post = post
        _getPostCommentsInteractor = getPostCommentsInteractor
    }

    @objc func refreshComments()
    {
        view?.showLoading()
        _getPostCommentsInteractor.resume(postId: _post.id) { [weak self] result in
            guard let selfBlocked = self else {
                return
            }

            DispatchQueue.main.async {
                selfBlocked.view?.hideLoading()
                switch result {
                case .success(let comments):
                    selfBlocked.view?.showComments(comments)
                case .failure(let err):
                    switch err {
                    case .connectionError:
                        selfBlocked.view?.showNetworkError()
                    case .decodingError, .serverUnavailable:
                        selfBlocked.view?.showUnknownError()
                    case .noInternetConnection, .serverError:
                        selfBlocked.view?.showNoInternetConnection()
                    }
                }
            }
        }
    }
}

extension PostCommentsPresenter: Presenter
{
    func viewDidLoad()
    {
        refreshComments()
        view?.showTitle(postName: _post.title)
    }

    func viewWillAppear()
    {
    }

    func viewDidAppear()
    {
    }

    func viewWillDisappear()
    {
    }

    func viewDidDisappear()
    {
    }
}
