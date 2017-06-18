import tensorflow as tf
from tensorflow.examples.tutorials.mnist import input_data

def main(session):
    mnist = input_data.read_data_sets("../data/mnist/", one_hot=True)
    ex_of_mnist(mnist, session)

# (x, y) is each image and its label respectively
def ex_of_mnist(mnist, session, max_iteration = 1000):
    # [784, 10] means shape of tensor (rank for each dimension)
    w = tf.Variable(tf.zeros(shape=[784, 10]))
    x = tf.placeholder(tf.float32, shape=[None, 784])
    b = tf.Variable(tf.zeros([10]))
    probabilities = tf.nn.softmax(tf.matmul(x, w) + b)

    supervisors = tf.placeholder(tf.float32, [None, 10])
    cross_entropy = tf.reduce_mean(-tf.reduce_sum(supervisors * tf.log(probabilities), axis=1))

    train_step = tf.train.GradientDescentOptimizer(0.5).minimize(cross_entropy)
    session.run(tf.global_variables_initializer())

    for _ in range(max_iteration):
        images_vectors, label_vectors = mnist.train.next_batch(100)
        session.run(train_step, feed_dict={x: images_vectors, supervisors: label_vectors})

    print("==trained w==")
    print(session.run(w))
    print("==trained b==")
    print(session.run(b))

    correct_class = tf.argmax(supervisors, 1)
    predicted_class = tf.argmax(probabilities, 1)
    correct_prediction = tf.equal(correct_class, predicted_class)
    accuracy = tf.reduce_mean(tf.cast(correct_prediction, tf.float32))
    result = session.run(accuracy, feed_dict={x: mnist.test.images, supervisors: mnist.test.labels})
    print("accuracy is {0}".format(result))

session = tf.Session()
main(session)