import matplotlib.pyplot as plt
import numpy as np
from bayesian_decision_tree.classification import \
  PerpendicularClassificationTree
from examples import helper
from matplotlib import patches
from sklearn.metrics import accuracy_score


def plot_2d_perpendicular(root, X_train, y_train, info_train):
    plt.figure(figsize=[10, 16], dpi=75)

    n_classes = int(y_train.max()) + 1
    colormap = plt.get_cmap('gist_rainbow')

    def plot(X, y, info):
        for i in range(n_classes)[::-1]:
            class_i = y == i
            plt.plot(X[np.where(class_i)[0], 0],
                     X[np.where(class_i)[0], 1],
                     'o',
                     ms=4,
                     c=colormap(i/n_classes),
                     label='Class {}'.format(i),
                     alpha=0.5)

            bounds = ((X[:, 0].min(), X[:, 0].max()), (X[:, 1].min(), X[:, 1].max()))
            draw_node_2d_perpendicular(root, bounds, colormap, n_classes)
        plt.title(info)
        plt.xlabel('x0')
        plt.ylabel('x1')
        plt.legend()

    plt.subplot(111)
    plot(X_train, y_train, info_train)
    plt.gca().set_aspect(1)

    plt.show()


def draw_node_2d_perpendicular(node, bounds, colormap, n_classes):
    if node.is_leaf():
        x = bounds[0][0]
        y = bounds[1][0]
        w = bounds[0][1] - x
        h = bounds[1][1] - y

        mean = node._compute_posterior_mean()
        if not node.is_regression:
            mean = (np.arange(len(mean)) * mean).sum()

        plt.gca().add_patch(patches.Rectangle((x, y), w, h, color=colormap(mean/n_classes), alpha=0.1, linewidth=0))
    else:
        draw_node_2d_perpendicular(node.child1_, compute_child_bounds_2d_perpendicular(bounds, node, True), colormap, n_classes)
        draw_node_2d_perpendicular(node.child2_, compute_child_bounds_2d_perpendicular(bounds, node, False), colormap, n_classes)


def compute_child_bounds_2d_perpendicular(bounds, parent, lower):
    b = bounds[parent.split_dimension_]
    b = (b[0], min(b[1], parent.split_value_)) if lower else (max(b[0], parent.split_value_), b[1])
    return (b, bounds[1]) if parent.split_dimension_ == 0 else (bounds[0], b)


def compute_child_bounds_1d_perpendicular(bounds, parent, lower):
    b = bounds
    b = (b[0], min(b[1], parent.split_value_)) if lower else (max(b[0], parent.split_value_), b[1])
    return b


def draw_node_1d_perpendicular(node, bounds):
    if node.is_leaf():
        x0 = bounds[0]
        x1 = bounds[1]

        mean = node._compute_posterior_mean()
        # alpha = np.abs(mean-0.5)
        # alpha = max(0.1, alpha)  # make sure very faint colors become visibly colored
        # color = color0 if mean < 0.5 else color1
        plt.plot([x0, x1], [mean, mean], 'r')
    else:
        draw_node_1d_perpendicular(node.child1_, compute_child_bounds_1d_perpendicular(bounds, node, True))
        draw_node_1d_perpendicular(node.child2_, compute_child_bounds_1d_perpendicular(bounds, node, False))



if __name__ == '__main__':
  X_train = np.array([
    [0.9, 0.1],
    [0.9, 0.2],
    [0.2, 0.1],
    [0.1, 0.9],
    [0.9, 0.2],
    [0.95, 0.89],
    [0.09, 0.05],
    [0.11, 0.78],
  ])
  y_train = [[1], [0], [1], [0], [1], [0], [0], [0]]
  
  train = np.hstack((X_train, y_train))
  
  n_classes = len(np.unique(train[:, -1]))

  X_train = train[:, :-1]
  y_train = train[:, -1]

  # prior
  # prior_pseudo_observations = 1
  # prior = prior_pseudo_observations * np.ones(n_classes)
  prior = [0.7, 0.3]

  # model
  model = PerpendicularClassificationTree(
    partition_prior=0.8,
    prior=prior,
    delta=0,
    prune=True
  )

  # train
  model.fit(X_train, y_train)
  print(model)
  print()
  print('Tree depth and number of leaves: {}, {}'.format(model.get_depth(), model.get_n_leaves()))
  print('Feature importance:', model.feature_importance())

  # compute accuracy
  y_pred_train = model.predict(X_train)
  accuracy_train = accuracy_score(y_train, y_pred_train)
  info_train = 'Train accuracy: {:.4f} %'.format(100 * accuracy_train)
  print(info_train)

  plot_2d_perpendicular(model, X_train, y_train, info_train)
