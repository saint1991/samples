import tensorflow as tf


def main(session):
    ex_of_constants(session)
    ex_of_summation(session)
    ex_of_placeholder(session)
    ex_of_one_degree_logistic_regression(session)
    ex_of_matrix_ops(session)

def ex_of_constants(session):
    i = tf.constant(3.0, tf.float32)  # a node that represents constant
    j = tf.constant(4.0, tf.float32)  # another constant node
    result = session.run([i, j])      # path a list of nodes then the session produces a result as a tensor
    print("constants are {0} respectively".format(result))

def ex_of_summation(session):
    i = tf.constant(3.0, tf.float32)
    j = tf.constant(4.0, tf.float32)
    result = session.run(i + j)
    print("result of summation is {0}".format(result))

def ex_of_placeholder(session):
    x = tf.placeholder(tf.float32)                   # placeholder of float value named after x that can pass at runtime
    y = tf.placeholder(tf.float32)                   # placeholder of float value named after y that can pass at runtime
    result = session.run(x * y, {x: 2.0, y: 22.0})   # calculate expression with given values as params
    print("result of param ex is {0}".format(result))

def ex_of_one_degree_logistic_regression(session):

    # define y = kx + b
    # y = -0.3x + 0.3 at the beginning
    k = tf.Variable([-0.3], tf.float32)
    x = tf.placeholder(tf.float32)
    b = tf.Variable([0.3], tf.float32)
    model = k * x + b

    y = tf.placeholder(tf.float32)
    squared_each = tf.square(y - model)
    loss_function = tf.reduce_sum(squared_each)

    initialize = tf.global_variables_initializer()
    session.run(initialize)

    # minimize objective function (squared error inhere) using Gradient Decent approach with 0.01 as a learning rate
    optimizer = tf.train.GradientDescentOptimizer(0.01)
    train = optimizer.minimize(loss_function)

    # iterate optimization to minimize loss function
    for i in range(10000):
        session.run(train, {x: [1, 2, 3, 4], y: [10.4, 10.5, 10.6, 10.7]})
    trained_params = session.run([k, b])
    print("after trained, (k, b) becomes ({0}, {1}) respectively"
          .format(trained_params[0], trained_params[1]))

    # reassign value to variables
    trained_k = tf.assign(k, trained_params[0])
    trained_b = tf.assign(b, trained_params[1])
    session.run([trained_k, trained_b])
    result = session.run(loss_function, {x: [1, 2, 3, 4], y: [10.4, 10.5, 10.6, 10.7]})
    print("the value of loss function becomes {0}".format(result))

def ex_of_matrix_ops(session):
    w = tf.constant([
        [2, 2, 0],
        [0, 1, 0],
        [0, 0, 1]
    ], shape=[3, 3])
    x = tf.constant([
        [2, 3, 4, 5],
        [5, 6, 7, 8],
        [8, 9, 10, 11]
    ], shape=[3, 4])
    matprod = tf.matmul(w, x)
    print("result of mutmul is")
    print(session.run(matprod))

    b = tf.constant([1, 2, 3, 4], shape=[4])

    added = matprod + b
    print("the sum of matprod and b becomes")
    print(session.run(added))


# execution session
session = tf.Session()
main(session)
