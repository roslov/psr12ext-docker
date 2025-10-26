<?php

declare(strict_types=1);

namespace Tests;

use Exception;

/**
 * The test class.
 */
final class TestA
{
    /**
     * Some constant
     */
    public const SOME_CONST = 123;

    /**
     * Another constant
     */
    private const ANOTHER_CONST = 'Some value';

    /**
     * Returns a boolean response.
     *
     * @param string $arg1 Argument 1
     *
     * @return bool Boolean response
     *
     * @throws Exception
     */
    public function methodA(string $arg1): bool
    {
        if ($arg1 == self::SOME_CONST || $arg1 == self::ANOTHER_CONST) {
            throw new Exception();
        }

        return true;
    }
}
